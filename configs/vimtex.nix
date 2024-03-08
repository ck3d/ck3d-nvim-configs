{ config, pkgs, lib, ... }:
{
  configs.vimtex = {
    disable = !(config.hasLang "latex");
    plugins = [ pkgs.vimPlugins.vimtex ];
    vars.tex_flavor = "latex";
  };
}
