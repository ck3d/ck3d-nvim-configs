{
  description = "CK3Ds NVim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix2nvimrc.url = "github:ck3d/nix2nvimrc";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix2nvimrc,
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      inherit (import ./lib.nix lib) readDirNix;
    in
    {
      lib = import ./lib.nix;

      overlays.default = import ./overlay.nix;

      nix2nvimrcModules = readDirNix ./modules;
      nix2nvimrcConfigs = readDirNix ./configs;

      inherit (nixpkgs) legacyPackages;

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = builtins.attrValues self.overlays;
          };

          grouped-languages = rec {
            nvim-min = [ ];

            nvim-admin = [
              "nix"
              "yaml"
              "bash"
              "lua"
              "markdown"
              "markdown_inline"
              "json"
              "toml"
              "dockerfile"
            ];

            nvim-dev = nvim-admin ++ [
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
              "jq"
              "vue"
              "typescript"
              "xml"
              "plantuml"
              "typst"
              "csv"
            ];
          };

          nvims = builtins.listToAttrs (
            builtins.concatMap (
              group:
              let
                evaluation = lib.evalModules {
                  modules =
                    (nix2nvimrc.lib.modules pkgs)
                    ++ (builtins.attrValues self.nix2nvimrcModules)
                    ++ (builtins.attrValues self.nix2nvimrcConfigs)
                    ++ [
                      {
                        wrapper.name = group;
                        languages = grouped-languages.${group};
                      }
                    ];
                };
              in
              builtins.concatMap
                (
                  drv:
                  lib.optional (builtins.elem system drv.meta.platforms) {
                    name = drv.pname;
                    value = drv;
                  }
                )
                [
                  evaluation.config.wrapper.drv
                  evaluation.config.bubblewrap.drv
                ]
            ) (builtins.attrNames grouped-languages)
          );
        in
        nvims // { default = nvims.nvim-admin; } // pkgs.ck3dNvimPkgs
      );

      checks = forAllSystems (
        system:
        let
          packages = self.packages.${system};
        in
        packages
        // (builtins.foldl' (
          acc: package:
          acc
          // (lib.mapAttrs' (test: value: {
            name = package + "-test-" + test;
            inherit value;
          }) (packages.${package}.tests or { }))
        ) { } (builtins.attrNames packages))
      );
    };
}
