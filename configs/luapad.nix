{ pkgs, lib, config, nix2nvimrc, ... }:

{
  configs.luapad = {
    enable = config.hasLang "lua";
    plugins = [ pkgs.vimPlugins.nvim-luapad ];
    setup = { };
  };
}
