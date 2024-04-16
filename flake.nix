{
  description = "CK3Ds NVim configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix2nvimrc.url = "github:ck3d/nix2nvimrc";
  };

  outputs = { self, nixpkgs, nix2nvimrc }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      inherit (import ./lib.nix lib) readDirNix;

      overlays.default = import ./overlay.nix;
      nix2nvimrcModules = readDirNix ./modules;
      nix2nvimrcConfigs = readDirNix ./configs;

      nvimModules = map (i: i.file)
        ((builtins.attrValues nix2nvimrcModules)
          ++ (builtins.attrValues nix2nvimrcConfigs));
      enableModules = map (i: i.enabler)
        (builtins.attrValues nix2nvimrcConfigs);
    in
    {
      lib = import ./lib.nix;

      inherit overlays nvimModules;

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

            nvims = builtins.mapAttrs
              (name: languages:
                (lib.evalModules {
                  modules =
                    (nix2nvimrc.lib.modules pkgs)
                    ++ nvimModules
                    ++ enableModules
                    ++ [{
                      wrapper.name = name;
                      inherit languages;
                    }];
                }).config.wrapper.drv)
              {
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
