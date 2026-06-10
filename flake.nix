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

          baseModules =
            ((import nix2nvimrc).modules final)
            ++ (builtins.attrValues self.nix2nvimrcModules)
            ++ (builtins.attrValues self.nix2nvimrcConfigs);
        in
        {
          ${namespace} =
            (lib.concatMapAttrs (
              group: languages:
              let
                evaluation = lib.evalModules {
                  modules = baseModules ++ [
                    {
                      wrapper.name = group;
                      inherit languages;
                    }
                  ];
                };
                inherit (evaluation.config) wrapper sandbox;
              in
              {
                "${wrapper.drv.pname}" = wrapper.drv;
                "${sandbox.drv.pname}" = sandbox.drv;
              }
            ) grouped-languages)
            // {
              default = final.${namespace}.nvim-admin;
            };
        };

      checks = forAllSystems (
        system:
        let
          packages = self.packages.${system};
          packages-checks = lib.concatMapAttrs (
            name: pkg:
            lib.mapAttrs' (test: value: {
              name = "${name}-test-${test}";
              inherit value;
            }) (pkg.checks or { })
          ) packages;
        in
        packages // packages-checks
      );
    };
}
