{ pkgs, ... }:
{
  # CTRL-A/CTRL-X on dates
  configs.speeddating = {
    plugins = [ pkgs.vimPlugins.vim-speeddating ];
  };
}
