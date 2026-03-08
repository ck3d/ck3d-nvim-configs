{ pkgs, nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) luaExpr;
in
{
  configs.global = {
    after = [ "leader" ];
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
      relativenumber = false;
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
    lua = [
      ''
        -- https://github.com/neovim/neovim/issues/28845#issuecomment-2119058319
        vim.deprecate = vim.islist;
      ''
    ];
    keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
      [
        ""
        "<C-h>"
        "<C-w>h"
        { }
      ]
      [
        ""
        "<C-j>"
        "<C-w>j"
        { }
      ]
      [
        ""
        "<C-k>"
        "<C-w>k"
        { }
      ]
      [
        ""
        "<C-l>"
        "<C-w>l"
        { }
      ]
      [
        "n"
        "<F2>"
        "<Cmd>read !uuidgen<CR>"
        { desc = "Generate uuid"; }
      ]
      [
        "n"
        "<Leader>cd"
        "<Cmd>lcd %:p:h<CR>"
        { desc = "Change working directory"; }
      ]
      [
        "n"
        "n"
        "nzz"
        { }
      ]
      [
        "n"
        "N"
        "Nzz"
        { }
      ]
      [
        [
          "n"
          "v"
        ]
        "<Leader>d"
        "\"_d"
        { desc = "Delete to /dev/null"; }
      ]
      [
        "v"
        "<"
        "<gv"
        { desc = "Indent left"; }
      ]
      [
        "v"
        ">"
        ">gv"
        { desc = "Indent right"; }
      ]
      [
        "t"
        "<Esc>"
        "<C-\\><C-n>"
        { desc = "Close terminal"; }
      ]
      [
        "n"
        "gx"
        "<Cmd>call jobstart(['xdg-open', expand('<cfile>')])<CR>"
        { desc = "Open file"; }
      ]
      # https://stackoverflow.com/a/26504944
      [
        "n"
        "<Leader>h"
        "<Cmd>let &hls=(&hls == 1 ? 0 : 1)<CR>"
        { desc = "Toggle highlight search"; }
      ]
      # diagnostics
      [
        "n"
        "<Leader>e"
        (luaExpr "vim.diagnostic.open_float")
        { }
      ]
      [
        "n"
        "[d"
        (luaExpr "vim.diagnostic.goto_prev")
        { }
      ]
      [
        "n"
        "]d"
        (luaExpr "vim.diagnostic.goto_next")
        { }
      ]
      [
        "n"
        "<Leader>q"
        (luaExpr "vim.diagnostic.setloclist")
        { }
      ]
      [
        [
          "n"
          "v"
        ]
        "<Leader>y"
        "\"+y"
        { desc = "yank motion/selection to clipboard"; }
      ]
      [
        [
          "n"
          "v"
        ]
        "<Leader>Y"
        "\"+Y"
        { desc = "yank line to clipboard"; }
      ]
      [
        [
          "n"
          "v"
        ]
        "<Leader>d"
        "\"+d"
        { desc = "delete motion/selection to clipboard"; }
      ]
      [
        [
          "n"
          "v"
        ]
        "<Leader>D"
        "\"+D"
        { desc = "delete line to clipboard"; }
      ]
      [
        "n"
        "<Leader>p"
        "\"+p"
        { desc = "paste from clipboard after cursor"; }
      ]
      [
        "n"
        "<Leader>P"
        "\"+P"
        { desc = "paste from clipboard before cursor"; }
      ]
    ];
    vim = [ ./global.vim ];

    env.PATH.values = [
      (pkgs.hunspell.withDicts (di: [
        di.de-de
        di.en-us
      ]))
    ];
  };
}
