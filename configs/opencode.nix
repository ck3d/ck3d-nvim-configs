{ pkgs, ... }:
{
  configs.opencode = {
    plugins = [ pkgs.vimPlugins.opencode-nvim ];
    lua = [ (builtins.readFile ./opencode-config.lua) ];
  };
}
