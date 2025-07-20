{ pkgs, ... }:
{
  configs.otter = {
    plugins = [ pkgs.vimPlugins.otter-nvim ];
  };
}
