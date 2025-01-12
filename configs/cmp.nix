{ pkgs, ... }:
{
  configs.cmp = {
    plugins = with pkgs.vimPlugins; [
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp-treesitter
      cmp-nvim-lsp
      cmp-spell
      cmp-nvim-tags
      cmp-vsnip

      vim-vsnip
    ];
    setup.args = ./cmp_setup_args.lua;
  };
}
