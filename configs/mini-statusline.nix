{ pkgs, ... }:
{
  configs."mini.statusline" = {
    plugins = [ pkgs.vimPlugins.mini-statusline ];
    setup.args = { };
  };
}
