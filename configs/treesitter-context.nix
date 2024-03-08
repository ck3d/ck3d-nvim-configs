{ pkgs, ... }:
{
  configs.treesitter-context = {
    plugins = [ pkgs.vimPlugins.nvim-treesitter-context ];
    setup.args = {
      max_lines = 8;
    };
  };
}
