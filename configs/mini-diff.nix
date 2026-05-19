{ pkgs, ... }:
{
  configs."mini.diff" = {
    plugins = [ pkgs.vimPlugins.mini-diff ];
    setup.args = {
      view = {
        style = "sign";
        signs = {
          add = "+";
          change = "~";
          delete = "-";
        };
      };
    };
  };
}
