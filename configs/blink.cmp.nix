{ pkgs, ... }:
{
  configs."blink.cmp" = {
    plugins = [ pkgs.vimPlugins.blink-cmp ];
    setup.args = {
      # https://cmp.saghen.dev/configuration/keymap#enter
      keymap.preset = "enter";
    };
  };
}
