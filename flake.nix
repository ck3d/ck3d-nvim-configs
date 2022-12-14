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
          "lua"
          # activate after merge of
          "markdown"
          "json"
          "toml"
        ];
        nvim = with nixpkgs'; name: languages:
          let
            rc = nixpkgs'.writeText
              ("nvimrc-" + name)
              (nix2nvimrc.lib.toRc nixpkgs' {
                inherit languages;
                imports = [ ./config.nix ];
              });
          in
          runCommandLocal
            "nvim"
            {
              nativeBuildInputs = [
                makeWrapper
                # needed by plugin gitsigns
                gitMinimal
              ];
            }
            ''
              makeWrapper ${neovim-unwrapped}/bin/nvim $out/bin/nvim \
                --add-flags "-u NORC --cmd 'luafile ${rc}'"
              HOME=$(pwd) $out/bin/nvim --headless +"q" 2> err
              if [ -s err ]; then
                cat err
                false
              fi
            ''
        ;
        packages = builtins.mapAttrs nvim {
          admin = adminLanguages;
          dev = adminLanguages ++ [
            # treesitter
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
            "latex"
            "devicetree"
            "go"
            # no treesitter
            "xml"
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
