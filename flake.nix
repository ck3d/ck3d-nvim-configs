{
  description = "CK3Ds NVim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix2nvimrc.url = "github:ck3d/nix2nvimrc";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, nix2nvimrc }:
    utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import ./overlay.nix) ];
        nixpkgs' = import nixpkgs { inherit system overlays; };
        adminLanguages = [
          "nix"
          "yaml"
          "bash"
          # activate after merge of
          "markdown"
          "json"
          "toml"
        ];
        nvim = with nixpkgs'; name: languages: runCommandLocal
          "nvim"
          { nativeBuildInputs = [ makeWrapper ]; }
          ''
            makeWrapper ${neovim-unwrapped}/bin/nvim $out/bin/nvim \
              --add-flags "-u ${nixpkgs'.writeText ("nvimrc-" + name) (nix2nvimrc.lib.toRc nixpkgs' { inherit languages; imports = [ ./config.nix ];})}"
          '';
        packages = builtins.mapAttrs nvim {
          admin = adminLanguages;
          dev = adminLanguages ++ [
            # treesitter
            "lua"
            "rust"
            "beancount"
            "javascript"
            "html"
            "c"
            "cpp"
            "css"
            "make"
            "graphql"
            "python"
            "scheme"
            # no treesitter
            "xml"
            "tex"
            "jq"
            "plantuml"
            "dhall"
          ];
        };
      in
      {
        inherit packages;
        defaultPackage = packages.admin;
      });
}
