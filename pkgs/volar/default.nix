{ stdenv, pkgs }:
let
  nodePackages = import ./packages.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages."@volar/vue-language-server"
