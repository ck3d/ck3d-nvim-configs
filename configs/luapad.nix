{ pkgs, ... }:
{
  configs.luapad = {
    languages = [ "lua" ];
    plugins = [ pkgs.vimPlugins.nvim-luapad ];
    setup = { };
  };
}
