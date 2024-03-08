{ config, pkgs, nix2nvimrc, ... }:
{
  configs.trouble = {
    after = [ "leader" ];
    plugins = [ pkgs.vimPlugins.trouble-nvim ];
    setup.args = {
      icons = config.configs ? nvim-web-devicons;
    };
    keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
      [
        "n"
        "<Leader>xx"
        "<Cmd>TroubleToggle<CR>"
        { desc = "Toggle trouble list"; }
      ]
      [
        "n"
        "gR"
        "<Cmd>TroubleToggle lsp_references<CR>"
        { desc = "Toggle lsp reference trouble list"; }
      ]
    ];
  };
}
