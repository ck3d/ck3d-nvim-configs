{ pkgs, nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) toLuaFn luaExpr;
in
{
  configs.telescope = {
    after = [ "leader" ];
    plugins = with pkgs.vimPlugins; [
      telescope-fzy-native-nvim
      telescope-file-browser-nvim
      telescope-ui-select-nvim
    ];
    setup = { };
    lua = map (a: toLuaFn "require'telescope'.load_extension" [ a ]) [
      "fzy_native"
      "file_browser"
      "ui-select"
    ];
    # https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
    keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
      [ "n" "<Leader>ff" (luaExpr "require'telescope.builtin'.find_files") { desc = "Find file"; } ]
      [ "n" "<Leader>fF" (luaExpr "require'telescope.builtin'.git_files") { desc = "Find git file"; } ]
      [ "n" "<Leader>fg" (luaExpr "require'telescope.builtin'.live_grep") { desc = "Find line"; } ]
      [ "n" "<Leader>fb" (luaExpr "require'telescope.builtin'.buffers") { desc = "Find buffer"; } ]
      [ "n" "<Leader>fh" (luaExpr "require'telescope.builtin'.help_tags") { desc = "Find help tag"; } ]
      [ "n" "<Leader>fm" (luaExpr "require'telescope.builtin'.keymaps") { desc = "Find key mapping"; } ]
      [ "n" "<Leader>ft" "<Cmd>Telescope file_browser<CR>" { desc = "Find file via browser"; } ]
      [ "n" "<Leader>fT" (luaExpr "require'telescope.builtin'.tags") { desc = "Find help tag"; } ]
      [ "n" "<Leader>fc" (luaExpr "require'telescope.builtin'.commands") { desc = "Find command"; } ]
      [ "n" "<Leader>fq" (luaExpr "require'telescope.builtin'.quickfix") { desc = "Find in quickfix"; } ]
      [ "n" "<Leader>fr" (luaExpr "function() require'telescope.builtin'.find_files({cwd= '%:h'}) end") { desc = "Find file relative"; } ]
      [ "n" "<Leader>gs" (luaExpr "require'telescope.builtin'.git_status") { desc = "Git status"; } ]
      [ "n" "<Leader>wo" (luaExpr "require'telescope.builtin'.lsp_document_symbols") { desc = "Find LSP doc. symbol"; } ]
    ];
  };
}
