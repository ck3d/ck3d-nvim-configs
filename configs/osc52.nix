{ nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) toLua;
in
{
  configs.osc52.lua = [ (toLua ./osc52.lua) ];
}
