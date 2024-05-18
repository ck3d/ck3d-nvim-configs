{ pkgs, ... }:
{
  configs.vimtex = {
    languages = [ "latex" ];
    plugins = [ pkgs.vimPlugins.vimtex ];
    vars.tex_flavor = "latex";
  };
}
