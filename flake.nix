{
  description = "CK3Ds NVim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix2nvimrc = {
      url = "github:ck3d/nix2nvimrc";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix2nvimrc,
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      inherit (import ./lib.nix lib) readDirNix;

      namespace = "ck3d-nvim-configs";
    in
    {
      lib = import ./lib.nix;

      nix2nvimrcModules = readDirNix ./modules;
      nix2nvimrcConfigs = readDirNix ./configs;

      legacyPackages = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues self.overlays;
        }
      );

      packages = forAllSystems (system: self.legacyPackages.${system}.${namespace});

      formatter = forAllSystems (system: self.legacyPackages.${system}.nixfmt-tree);

      overlays.default =
        final: prev:
        let
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
              "regex"
              "kdl"
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
              "typescript"
              "xml"
              "plantuml"
              "typst"
              "csv"
              "nickel"
            ];
          };
        in
        {
          ${namespace} =
            builtins.listToAttrs (
              builtins.concatMap (
                group:
                let
                  evaluation = lib.evalModules {
                    modules =
                      ((import nix2nvimrc).modules final)
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
                map
                  (drv: {
                    name = drv.pname;
                    value = drv;
                  })
                  [
                    evaluation.config.wrapper.drv
                    evaluation.config.sandbox.drv
                  ]
              ) (builtins.attrNames grouped-languages)
            )
            // {
              default = final.${namespace}.nvim-admin;
            };
        };

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
