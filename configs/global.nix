{ config, pkgs, lib, nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) toLuaFn luaExpr;
in
{
  configs.global = {
    after = [ "leader" ];
    plugins = with pkgs.vimPlugins; [
      vim-speeddating # CTRL-A/CTRL-X on dates

      registers-nvim
      # TODO: test neuron-vim
      # TODO: test rust-vim
    ]
    ++ lib.optional (config.hasLang "plantuml") plantuml-syntax
    ;
    opts = {
      wrapscan = false;
      termguicolors = true;
      colorcolumn = "80";
      winwidth = 80;
      ignorecase = true;
      smartcase = true;
      showmatch = true;
      undofile = true;
      visualbell = true;
      cursorline = true;
      cursorlineopt = "number";
      expandtab = true;
      shiftwidth = 2;
      number = true;
      relativenumber = true;
      foldmethod = "indent";
      foldlevelstart = 99;
      linebreak = true;
      scrolloff = 2;
      sidescrolloff = 3;
      listchars = "tab:▸ ,trail:␣,nbsp:~";
      list = true;
      signcolumn = "yes";
      splitbelow = true;
      splitright = true;
      updatetime = 300;
      formatoptions = luaExpr "vim.o.formatoptions .. 'n'";
      background = "light";
      completeopt = "menu,menuone,noselect";
    };
    keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
      [ "" "<C-h>" "<C-w>h" { } ]
      [ "" "<C-j>" "<C-w>j" { } ]
      [ "" "<C-k>" "<C-w>k" { } ]
      [ "" "<C-l>" "<C-w>l" { } ]
      [ "n" "<F2>" "<Cmd>read !uuidgen<CR>" { desc = "Generate uuid"; } ]
      [ "n" "<Leader>cd" "<Cmd>lcd %:p:h<CR>" { desc = "Change working directory"; } ]
      [ "n" "<Leader>n" "<Cmd>bnext<CR>" { } ]
      [ "n" "<Leader>p" "<Cmd>bprevious<CR>" { } ]
      [ "n" "n" "nzz" { } ]
      [ "n" "N" "Nzz" { } ]
      [ [ "n" "v" ] "<Leader>d" "\"_d" { desc = "Delete to /dev/null"; } ]
      [ "v" "<" "<gv" { desc = "Indent left"; } ]
      [ "v" ">" ">gv" { desc = "Indent right"; } ]
      [ "t" "<Esc>" "<C-\\><C-n>" { desc = "Close terminal"; } ]
      [ "n" "gx" "<Cmd>call jobstart(['xdg-open', expand('<cfile>')])<CR>" { desc = "Open file"; } ]
      # https://stackoverflow.com/a/26504944
      [ "n" "<Leader>h" "<Cmd>let &hls=(&hls == 1 ? 0 : 1)<CR>" { desc = "Toggle highlight search"; } ]
      # diagnostics
      [ "n" "<Leader>e" (luaExpr "vim.diagnostic.open_float") { } ]
      [ "n" "[d" (luaExpr "vim.diagnostic.goto_prev") { } ]
      [ "n" "]d" (luaExpr "vim.diagnostic.goto_next") { } ]
      [ "n" "<Leader>q" (luaExpr "vim.diagnostic.setloclist") { } ]
    ];
    vim = [ ./global.vim ];
  };
}
