{ pkgs, config, ... }:
{
  # CTRL-A/CTRL-X on dates
  configs.plantuml-syntax = {
    enable = config.hasLang "plantuml";
    plugins = [ pkgs.vimPlugins.vim-speeddating ];
  };
}
