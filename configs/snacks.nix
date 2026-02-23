{ pkgs, nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) luaExpr;
in
{
  configs.snacks = {
    plugins = [ pkgs.vimPlugins.snacks-nvim ];
    setup.args = {
      input.enable = true;
      picker.enable = true;
    };
  };
}
