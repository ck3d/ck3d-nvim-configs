{ pkgs, ... }:
{
  # CTRL-A/CTRL-X on dates
  configs.plantuml-syntax = {
    languages = [ "plantuml" ];
    plugins = [ pkgs.vimPlugins.vim-speeddating ];
  };
}
