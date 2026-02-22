{ pkgs, ... }:
{
  configs."blink.cmp" = {
    plugins = [ pkgs.vimPlugins.blink-cmp ];
    setup = { };
  };
}
