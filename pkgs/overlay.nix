final: prev: {
  ck3dNvimPkgs = builtins.listToAttrs
    (map
      (dir: {
        name = dir;
        value = final.callPackage (./. + "/${dir}/") { };
      })
      (import ./dirs.nix));
}
