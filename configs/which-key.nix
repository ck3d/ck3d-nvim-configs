{ pkgs, ... }:
{
  configs.which-key = {
    plugins = [ pkgs.vimPlugins.which-key-nvim ];
    setup = { };
  };
}
