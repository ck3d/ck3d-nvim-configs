final: prev: {
  ck3dNvimPkgs = builtins.mapAttrs (name: value: final.callPackage (./pkgs + "/${name}/") { }) (
    builtins.readDir ./pkgs
  );
}
