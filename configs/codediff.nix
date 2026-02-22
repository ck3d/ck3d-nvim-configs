{ pkgs, ... }:
{
  configs.codediff = {
    plugins = [ pkgs.vimPlugins.codediff-nvim ];
    setup = { };
  };
}
