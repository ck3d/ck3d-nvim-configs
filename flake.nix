{
  description = "CK3Ds NVim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix2nvimrc.url = "github:ck3d/nix2nvimrc";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, nix2nvimrc }:
    let
      overlays.default = import ./pkgs/overlay.nix;
    in
    { inherit overlays; }
    // (utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
        };
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
        nvim = name: languages:
          let
            rc = pkgs.writeText
              ("nvimrc-" + name)
              (nix2nvimrc.lib.toRc pkgs {
                inherit languages;
                imports = [ ./config.nix ];
              });
            mainProgram = "nvim";
          in
          pkgs.runCommandLocal name
            {
              nativeBuildInputs = [
                pkgs.makeWrapper
                # needed by plugin gitsigns
                pkgs.gitMinimal
              ];
              meta = { inherit mainProgram; };
            }
            ''
              makeWrapper ${pkgs.neovim-unwrapped}/bin/nvim $out/bin/${mainProgram} \
                --add-flags "-u NORC --cmd 'luafile ${rc}'"
              HOME=$(pwd) $out/bin/nvim --headless +"q" 2> err
              if [ -s err ]; then
                cat err
                false
              fi
            ''
        ;

        nvims = builtins.mapAttrs nvim {
          nvim-admin = adminLanguages;
          nvim-dev = adminLanguages ++ [
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
            "dhall"
            "jq"
            "vue"
            # no treesitter
            "xml"
            "plantuml"
          ];
        };

      in
      {
        packages = nvims
        // { default = nvims.nvim-admin; }
        // pkgs.ck3dNvimPkgs;
      }));
}
