lib: {
  readDirNix =
    dir:
    lib.mapAttrs' (name: _: {
      name = lib.removeSuffix ".nix" name;
      value = dir + "/${name}";
    }) (lib.filterAttrs (name: _: lib.hasSuffix ".nix" name) (builtins.readDir dir));
}
