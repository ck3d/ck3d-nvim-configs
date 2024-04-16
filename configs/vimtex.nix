{ config, pkgs, lib, ... }:
{
  configs.vimtex = {
    enable = config.hasLang "latex";
    plugins = [ pkgs.vimPlugins.vimtex ];
    vars.tex_flavor = "latex";
  };
}
