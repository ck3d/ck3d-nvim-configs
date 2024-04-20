{ pkgs, lib, config, ... }:
{
  configs.scrollview = {
    plugins = [ pkgs.vimPlugins.nvim-scrollview ];
    setup = { };
  };
}
