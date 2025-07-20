{ pkgs, ... }:
{
  configs.markview = {
    plugins = [ pkgs.vimPlugins.markview-nvim ];
    setup = { };
  };
}
