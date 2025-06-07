{ pkgs, ... }:
{
  configs.plantuml-syntax = {
    languages = [ "plantuml" ];
    plugins = [ pkgs.vimPlugins.plantuml-syntax ];
  };
}
