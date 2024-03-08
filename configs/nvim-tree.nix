{ pkgs, nix2nvimrc, ... }:
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
    keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
      [ "n" "<C-n>" "<Cmd>NvimTreeToggle<CR>" { } ]
    ];
  };
}
