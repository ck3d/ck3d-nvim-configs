lib: {
  readDirNix =
    dir:
    let
      suffix = ".nix";
    in
    builtins.listToAttrs (
      map (f: {
        name = lib.removeSuffix suffix f;
        value = dir + "/${f}";
      }) (builtins.filter (lib.hasSuffix suffix) (builtins.attrNames (builtins.readDir dir)))
    );
}
