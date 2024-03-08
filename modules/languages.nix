{ config, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    languages = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    hasLang = mkOption {
      type = types.functionTo types.bool;
      default = lang: builtins.any (i: i == lang) config.languages;
    };
  };
}
