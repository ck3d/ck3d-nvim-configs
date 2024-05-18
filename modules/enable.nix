{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options = {
    configs = mkOption {
      type = types.attrsOf (types.submodule {
        options.enable = mkEnableOption "Enable Configuration";
      });
    };
  };
}
