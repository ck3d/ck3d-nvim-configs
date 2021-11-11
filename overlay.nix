final: prev: {
  ck3dNvimPkgs = builtins.listToAttrs
    (map
      (dir: {
        name = dir;
        value = final.callPackage (./. + "/pkgs/${dir}/") { };
      })
      (import ./pkgs/dirs.nix));
}
