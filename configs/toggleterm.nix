{ pkgs, ... }:
{
  configs.toggleterm = {
    plugins = [ pkgs.vimPlugins.toggleterm-nvim ];
    setup.args = {
      open_mapping = "<c-t>";
      shade_terminals = false;
    };
  };
}
