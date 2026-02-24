{ pkgs, ... }:
{
  configs.nvim-tree = {
    plugins = [ pkgs.vimPlugins.nvim-tree-lua ];
    setup.args = {
      # https://github.com/ahmedkhalf/project.nvim
      sync_root_with_cwd = true;
      respect_buf_cwd = true;
      update_focused_file = {
        enable = true;
        update_root = true;
      };
    };
    lua = [
      ''
        vim.keymap.set("n", "<C-n>", "<Cmd>NvimTreeToggle<CR>")
      ''
    ];
  };
}
