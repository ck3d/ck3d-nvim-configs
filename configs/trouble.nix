{
  config,
  pkgs,
  nix2nvimrc,
  ...
}:
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
        "<leader>xx"
        "<cmd>Trouble diagnostics toggle<cr>"
        { desc = "Diagnostics (Trouble)"; }
      ]
      [
        "n"
        "<leader>xX"
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"
        { desc = "Buffer Diagnostics (Trouble)"; }
      ]
      [
        "n"
        "<leader>cs"
        "<cmd>Trouble symbols toggle focus=false<cr>"
        { desc = "Symbols (Trouble)"; }
      ]
      [
        "n"
        "<leader>cl"
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>"
        { desc = "LSP Definitions / references / ... (Trouble)"; }
      ]
      [
        "n"
        "<leader>xL"
        "<cmd>Trouble loclist toggle<cr>"
        { desc = "Location List (Trouble)"; }
      ]
      [
        "n"
        "<leader>xQ"
        "<cmd>Trouble qflist toggle<cr>"
        { desc = "Quickfix List (Trouble)"; }
      ]
    ];
  };
}
