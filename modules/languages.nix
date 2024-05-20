{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    languages = mkOption {
      type = types.listOf types.str;
    };
    hasLang = mkOption {
      type = types.functionTo types.bool;
      default = lang: builtins.any (i: i == lang) config.languages;
    };

    configs = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          languages = mkOption {
            type = types.listOf types.str;
            default = [ ];
          };
        };
      });
    };
  };
  config = {
    enableFns = [
      (m: (m.languages == [ ])
        || (builtins.length (lib.intersectLists config.languages m.languages) > 0))
    ];
  };
}
