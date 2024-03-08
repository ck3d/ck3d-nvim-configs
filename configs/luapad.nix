{ pkgs, lib, config, nix2nvimrc, ... }:

{
  configs.luapad = {
    disable = !(config.hasLang "lua");
    plugins = [ pkgs.vimPlugins.nvim-luapad ];
    setup = { };
  };
}
