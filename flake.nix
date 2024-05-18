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
    in
    {
      lib = import ./lib.nix;

      overlays.default = import ./overlay.nix;

      nix2nvimrcModules = readDirNix ./modules;
      nix2nvimrcConfigs = readDirNix ./configs;

      packages = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = builtins.attrValues self.overlays;
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
                    ++ (builtins.attrValues self.nix2nvimrcModules)
                    ++ (builtins.attrValues self.nix2nvimrcConfigs)
                    ++ [{
                      wrapper.name = name;
                      inherit languages;
                      enableFn = m: (m.languages == [ ])
                      || (builtins.length (lib.intersectLists languages m.languages) > 0);
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
