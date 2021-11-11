{
  description = "CK3Ds NVim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix2nvimrc.url = "github:ck3d/nix2nvimrc";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, nix2nvimrc }:
    utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import ./overlay.nix) ];
        nixpkgs' = import nixpkgs { inherit system overlays; };
        nvimrc = nix2nvimrc.lib.toRc nixpkgs' ./config.nix;
      in
      {
        defaultPackage = with nixpkgs'; runCommandLocal "nvim" { nativeBuildInputs = [ makeWrapper ]; } ''
          makeWrapper ${neovim-unwrapped}/bin/nvim $out/bin/nvim \
            --add-flags "-u ${writeText "nvimrc" nvimrc}"
        '';
      });
}
