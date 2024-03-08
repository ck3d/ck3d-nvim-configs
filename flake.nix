{
  description = "CK3Ds NVim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix2nvimrc.url = "github:ck3d/nix2nvimrc";
  };

  outputs = { self, nixpkgs, nix2nvimrc }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      inherit (import ./lib.nix lib) readDirNix;
    in
    rec {
      lib = import ./lib.nix;

      overlays.default = import ./overlay.nix;

      nix2nvimrcModules = readDirNix ./modules;
      nix2nvimrcConfigs = readDirNix ./configs;

      packages = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = builtins.attrValues overlays;

              config.permittedInsecurePackages = [
                "openssl-1.1.1u"
              ];
            };
            adminLanguages = [
              "nix"
              "yaml"
              "bash"
              "lua"
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
                    imports = builtins.attrValues nix2nvimrcModules
                      ++ builtins.attrValues nix2nvimrcConfigs;
                  });
                mainProgram = "nvim";

                neovim = pkgs.neovim-unwrapped.override {
                  # Disable bundled parsers, we manage it on our own
                  # The bundle was not update in the last 12 month. The C
                  # parser is not compatible with the latest nvim treesitter
                  # plugin. See also
                  # https://github.com/NixOS/nixpkgs/pull/227159
                  treesitter-parsers = { };
                };
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
                  makeWrapper ${neovim}/bin/nvim $out/bin/${mainProgram} \
                    --add-flags "-u NORC --cmd 'luafile ${rc}'" \
                    --suffix PATH ":" "${pkgs.nixpkgs-fmt}/bin"
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
                "typescript"
                "xml"
                "plantuml"
              ];
            };
          in
          nvims
          // { default = nvims.nvim-admin; }
          // pkgs.ck3dNvimPkgs
        );
    };
}
