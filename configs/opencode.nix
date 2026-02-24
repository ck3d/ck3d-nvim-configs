{ pkgs, ... }:
{
  configs.opencode = {
    plugins = [ pkgs.vimPlugins.opencode-nvim ];
    lua = [ ./opencode-config.lua ];
  };
}
