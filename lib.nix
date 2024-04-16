lib:
{
  readDirNix = dir:
    let
      suffix = ".nix";
    in
    builtins.listToAttrs
      (map
        (f: rec {
          name = lib.removeSuffix suffix f;
          value = {
            file = dir + "/${f}";
            enabler = { configs.${name}.enable = lib.mkDefault true; };
          };
        })
        (builtins.filter
          (lib.hasSuffix suffix)
          (builtins.attrNames (builtins.readDir dir))));
}
