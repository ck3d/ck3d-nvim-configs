{ pkgs, ... }:
{
  configs."mini.icons" = {
    plugins = [ pkgs.vimPlugins.mini-icons ];
    setup.args = { };
    lua = [ "require('mini.icons').mock_nvim_web_devicons()" ];
  };
}
