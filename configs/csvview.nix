{ pkgs, ... }:
{
  configs.csvview = {
    languages = [ "csv" ];
    plugins = [ pkgs.vimPlugins.csvview-nvim ];
    setup = { };
  };
}
