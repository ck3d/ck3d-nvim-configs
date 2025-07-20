{ pkgs, ... }:
{
  configs.oil = {
    plugins = [ pkgs.vimPlugins.oil-nvim ];
    setup = { };
  };
}
