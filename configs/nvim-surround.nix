{ pkgs, ... }:
{
  configs.nvim-surround = {
    plugins = [ pkgs.vimPlugins.nvim-surround ];
    setup = { };
  };
}
