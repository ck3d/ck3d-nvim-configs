{ pkgs, lib, config, ... }:
{
  configs.scrollbar = {
    plugins = [ pkgs.vimPlugins.nvim-scrollbar ];
    setup = { };
    lua = lib.optional (config.configs ? gitsigns)
      "require('scrollbar.handlers.gitsigns').setup()";
  };
}
