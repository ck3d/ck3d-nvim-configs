{ pkgs, nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) luaExpr toKeymap;
in
{
  configs.snacks = {
    after = [ "leader" ];
    plugins = [ pkgs.vimPlugins.snacks-nvim ];
    setup.args = {
      input.enable = true;
      picker.enable = true;
      notifier.enable = true;
      terminal.enable = true;
      lazygit.enable = true;
      words.enable = true;
      image.enable = true;
      scroll.enable = true;
      statuscolumn.enable = true;
      gitblame.enable = true;
    };
    keymaps = map (toKeymap { silent = true; }) [
      [
        "n"
        "<Leader>ff"
        (luaExpr "function() require('snacks').picker.files() end")
        { desc = "Find file"; }
      ]
      [
        "n"
        "<Leader>fF"
        (luaExpr "function() require('snacks').picker.git_files() end")
        { desc = "Find git file"; }
      ]
      [
        "n"
        "<Leader>fg"
        (luaExpr "function() require('snacks').picker.grep() end")
        { desc = "Find line"; }
      ]
      [
        "n"
        "<Leader>fb"
        (luaExpr "function() require('snacks').picker.buffers() end")
        { desc = "Find buffer"; }
      ]
      [
        "n"
        "<Leader>fh"
        (luaExpr "function() require('snacks').picker.help() end")
        { desc = "Find help tag"; }
      ]
      [
        "n"
        "<Leader>fm"
        (luaExpr "function() require('snacks').picker.keymaps() end")
        { desc = "Find key mapping"; }
      ]
      [
        "n"
        "<Leader>fc"
        (luaExpr "function() require('snacks').picker.commands() end")
        { desc = "Find command"; }
      ]
      [
        "n"
        "<Leader>fq"
        (luaExpr "function() require('snacks').picker.qflist() end")
        { desc = "Find in quickfix"; }
      ]
      [
        "n"
        "<Leader>fD"
        (luaExpr "function() require('snacks').picker.diagnostics() end")
        { desc = "Find in diagnostics"; }
      ]
      [
        "n"
        "<Leader>fr"
        (luaExpr "function() require('snacks').picker.files({cwd = vim.fn.expand('%:h')}) end")
        { desc = "Find file relative"; }
      ]
      [
        "n"
        "<Leader>fR"
        (luaExpr "function() require('snacks').picker.registers() end")
        { desc = "Find in registers"; }
      ]
      [
        "n"
        "<Leader>gs"
        (luaExpr "function() require('snacks').picker.git_status() end")
        { desc = "Git status"; }
      ]
      [
        "n"
        "<Leader>gg"
        (luaExpr "function() require('snacks').lazygit() end")
        { desc = "Lazygit"; }
      ]
      [
        "n"
        "<Leader>gb"
        (luaExpr "function() require('snacks').git.blame_line() end")
        { desc = "Git blame line"; }
      ]
      [
        "n"
        "<Leader>wo"
        (luaExpr "function() require('snacks').picker.lsp_symbols() end")
        { desc = "Find LSP doc. symbol"; }
      ]
      [
        "n"
        "<Leader>c"
        (luaExpr "function() require('snacks').bufdelete() end")
        { desc = "Close buffer"; }
      ]
      [
        "n"
        "<c-t>"
        (luaExpr "function() require('snacks').terminal.toggle() end")
        { desc = "Toggle Terminal"; }
      ]
      [
        "t"
        "<c-t>"
        (luaExpr "function() require('snacks').terminal.toggle() end")
        { desc = "Toggle Terminal"; }
      ]
    ];
    env.PATH.values = [ pkgs.mermaid-cli ];
  };
}
