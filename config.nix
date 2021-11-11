{ config, pkgs, lib, ... }:
{
  configs = with pkgs.vimPlugins; [
    {
      name = "global";
      treesitter.languages = [ "lua" "nix" "yaml" "markdown" "bash" "json" "rust" "javascript" "html" "c" "cpp" "css" "toml" ];
      plugins = [
        ale # replaced Syntastic
        # TODO: test:
        # https://github.com/TimUntersberger/neogit
        fugitive

        neoformat
        surround
        vim-speeddating # CTRL-A/CTRL-X on dates

        jq-vim

        registers-nvim

        playground
        plantuml-syntax
        vim-beancount
        vim-graphql
        pkgs.ck3dNvimPkgs.vimPlugins.nvim-luapad
        # TODO: test neuron-vim
        # TODO: test rust-vim

        gruvbox-nvim
        lush-nvim
      ];
      opts = {
        wrapscan = false;
        hidden = true;
        termguicolors = true;
        colorcolumn = "80";
        winwidth = 80;
        ignorecase = true;
        smartcase = true;
        showmatch = true;
        undofile = true;
        visualbell = true;
        cursorline = true;
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
        guifont = "Monolisa:h9";
        mouse = "nv";
        signcolumn = "yes";
        splitbelow = true;
        splitright = true;
        updatetime = 300;
        formatoptions = lib.luaExpr "vim.o.formatoptions .. 'n'";
        background = "light";
        completeopt = "menu,menuone,noselect";
      };
      keymaps = map (lib.toKeymap { noremap = true; silent = true; }) [
        [ "" "<C-h>" "<C-w>h" { } ]
        [ "" "<C-j>" "<C-w>j" { } ]
        [ "" "<C-k>" "<C-w>k" { } ]
        [ "" "<C-l>" "<C-w>l" { } ]
        [ "n" "<F2>" "<Cmd>read !uuidgen<CR>" { } ]
        [ "n" "<Leader>cd" "<Cmd>lcd %:p:h<CR>" { } ]
        [ "n" "<Leader>n" "<Cmd>bnext<CR>" { } ]
        [ "n" "<Leader>p" "<Cmd>bprevious<CR>" { } ]
        [ "n" "Y" "yg$" { } ]
        [ "n" "n" "nzzzv" { } ]
        [ "n" "N" "Nzzzv" { } ]
        [ "n" "<Leader>y" "\"+y" { } ]
        [ "v" "<Leader>y" "\"+y" { } ]
        [ "n" "<Leader>Y" "gg\"+yG" { } ]
        [ "n" "<Leader>d" "\"_d" { } ]
        [ "v" "<Leader>d" "\"_d" { } ]
        [ "v" "<" "<gv" { } ]
        [ "v" ">" ">gv" { } ]
        [ "t" "<Esc>" "<C-\\><C-n>" { } ]
        [ "n" "gx" "<Cmd>call jobstart(['xdg-open', expand('<cfile>')])<CR>" { } ]
        # https://stackoverflow.com/a/26504944
        [ "n" "<Leader>h" "<Cmd>let &hls=(&hls == 1 ? 0 : 1)<CR>" { } ]
      ];
      vars = {
        mapleader = " ";
        neovide_cursor_antialiasing = true;
        neovide_cursor_vfx_mode = "pixiedust";
      };
    }
    {
      name = "gitsigns";
      plugins = [ gitsigns-nvim ];
      setup = { };
    }
    {
      name = "nvim-tree";
      plugins = [ nvim-tree-lua ];
      setup = { };
    }
    {
      name = "which-key";
      plugins = [ which-key-nvim ];
      setup = { };
    }
    {
      name = "Comment";
      plugins = [ comment-nvim ];
      setup = { };
    }
    {
      name = "toggleterm";
      plugins = [ toggleterm-nvim ];
      setup = { open_mapping = "<c-t>"; };
    }
    {
      name = "nvim-web-devicons";
      plugins = [ nvim-web-devicons ];
      setup = { default = true; };
    }
    {
      name = "bufferline";
      plugins = [ bufferline-nvim ];
      setup = { options.diagnostics = "nvim_lsp"; };
      keymaps = map (lib.toKeymap { noremap = true; silent = true; }) [
        [ "n" "gb" "<Cmd>BufferLinePick<CR>" { } ]
      ];
    }
    {
      name = "vim-rooter";
      plugins = [ vim-rooter ];
      vars.rooter_patterns = [
        ".git"
        "Cargo.toml"
        ".lua-format"
        "default.nix"
        "flake.nix"
      ];
    }
    {
      name = "telescope";
      plugins = [ telescope-nvim plenary-nvim popup-nvim ];
      # https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
      setup.defaults = {
        file_sorter = lib.luaExpr "require'telescope.sorters'.get_fzy_sorter";
        generic_sorter = lib.luaExpr "require'telescope.sorters'.get_fzy_sorter";
      };
      keymaps = map (lib.toKeymap { noremap = true; silent = true; }) [
        [ "n" "<Leader>ff" "<Cmd>Telescope find_files<CR>" { } ]
        [ "n" "<Leader>fF" "<Cmd>Telescope git_files<CR>" { } ]
        [ "n" "<Leader>fg" "<Cmd>Telescope live_grep<CR>" { } ]
        [ "n" "<Leader>fb" "<Cmd>Telescope buffers<CR>" { } ]
        [ "n" "<Leader>fh" "<Cmd>Telescope help_tags<CR>" { } ]
        [ "n" "<Leader>ft" "<Cmd>lua require'telescope.builtin'.file_browser({cwd= '%:h'})<CR>" { } ]
        [ "n" "<Leader>fT" "<Cmd>Telescope tags<CR>" { } ]
        [ "n" "<Leader>fc" "<Cmd>Telescope commands<CR>" { } ]
        [ "n" "<Leader>fq" "<Cmd>Telescope quickfix<CR>" { } ]
        [ "n" "<Leader>fd" "<Cmd>lua require'telescope.builtin'.git_files({cwd= '~/dotfiles/'})<CR>" { } ]
        [ "n" "<Leader>fr" "<Cmd>lua require'telescope.builtin'.find_files({cwd= '%:h'})<CR>" { } ]
      ];
    }
    {
      name = "neoscroll";
      plugins = [ neoscroll-nvim ];
      setup = { };
    }
    {
      name = "nvim-treesitter";
      plugins = [ nvim-treesitter ];
      setupFn = "require'nvim-treesitter.configs'.setup";
      setup = {
        highlight.enable = true;
        incremental_selection.enable = true;
        textobjects.enable = true;
        playground.enable = true;
      };
    }
    {
      name = "lualine";
      plugins = [ lualine-nvim ];
      setup = {
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" ];
          lualine_c = [ (lib.luaExpr "{'filename', path = 1}") ];
          lualine_x = [ (lib.luaExpr "{require'lsp-status'.status}") "diff" "filetype" "b:toggle_number" ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
        options = { theme = "gruvbox_${config.opt.background}"; };
      };
    }
    {
      name = "lsp_extensions";
      plugins = [ lsp_extensions-nvim ];
      vim = [
        "autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = 'Comment', enabled = {'TypeHint', 'ChainingHint', 'ParameterHint'} }"
      ];
    }
    {
      name = "cmp";
      plugins = [
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-nvim-lua
        cmp-treesitter
        cmp-nvim-lsp
        cmp-spell
        pkgs.ck3dNvimPkgs.vimPlugins.cmp-nvim-tags
        cmp-vsnip

        vim-vsnip
      ];
      setup = {
        snippet = {
          expand = lib.luaExpr "function(args) vim.fn['vsnip#anonymous'](args.body) end";
        };
        sources = [
          { name = "vsnip"; }
          { name = "nvim_lua"; }
          { name = "nvim_lsp"; }
          { name = "treesitter"; }
          { name = "path"; keyword_length = 2; }
          { name = "tags"; keyword_length = 4; }
          { name = "buffer"; keyword_length = 4; }
          { name = "spell"; keyword_length = 4; }
        ];
      };
    }
    {
      name = "indentLine";
      plugins = [ indentLine ];
      vars.indentLine_enabled = 0;
      vars.indentLine_char = "⎸";
      vim = [ "autocmd FileType yaml IndentLinesEnable" ];
    }
    {
      name = "sneak";
      plugins = [ vim-sneak ];
      vars."sneak#label" = true;
    }
    {
      name = "quick-scope";
      plugins = [ quick-scope ];
      vars.qs_highlight_on_keys = [ "f" "F" "t" "T" ];
    }
    {
      name = "nix-lspconfig";
      lspconfig = {
        servers = {
          rnix = { pkg = pkgs.rnix-lsp; };
          tsserver = { pkg = pkgs.nodePackages.typescript-language-server; };
          rust_analyzer = { pkg = pkgs.rust-analyzer; };
          bashls = { pkg = pkgs.nodePackages.bash-language-server; };
          yamlls = { pkg = pkgs.nodePackages.yaml-language-server; };
          sumneko_lua = {
            pkg = pkgs.sumneko-lua-language-server;
            config = {
              cmd = [ "lua-language-server" ];
              settings.Lua = ./sumneko_lua.config.lua;
            };
          };
          lemminx = {
            pkg = pkgs.ck3dNvimPkgs.lemminx;
            config = {
              cmd = [ "lemminx" ];
              filetypes = [ "xslt" ];
            };
          };
        };

        capabilities = lib.luaExpr "require'cmp_nvim_lsp'.update_capabilities(vim.tbl_extend('keep', vim.lsp.protocol.make_client_capabilities(), require'lsp-status'.capabilities))";

        keymaps = map (lib.toKeymap { noremap = true; silent = true; }) [
          [ "n" "gD" "<cmd>lua vim.lsp.buf.declaration()<CR>" { } ]
          [ "n" "gd" "<cmd>lua vim.lsp.buf.definition()<CR>" { } ]
          [ "n" "K" "<cmd>lua vim.lsp.buf.hover()<CR>" { } ]
          [ "n" "gi" "<cmd>lua vim.lsp.buf.implementation()<CR>" { } ]
          [ "n" "<C-k>" "<cmd>lua vim.lsp.buf.signature_help()<CR>" { } ]
          [ "n" "<Leader>wa" "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>" { } ]
          [ "n" "<Leader>wr" "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>" { } ]
          [ "n" "<Leader>wl" "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>" { } ]
          [ "n" "<Leader>D" "<cmd>lua vim.lsp.buf.type_definition()<CR>" { } ]
          [ "n" "<Leader>rn" "<cmd>lua vim.lsp.buf.rename()<CR>" { } ]
          [ "n" "<Leader>ca" "<cmd>lua vim.lsp.buf.code_action()<CR>" { } ]
          [ "n" "gr" "<cmd>lua vim.lsp.buf.references()<CR>" { } ]
          [ "n" "<Leader>e" "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>" { } ]
          [ "n" "[d" "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>" { } ]
          [ "n" "]d" "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>" { } ]
          [ "n" "<Leader>q" "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>" { } ]
          [ "n" "<Leader>F" "<cmd>lua vim.lsp.buf.formatting()<CR>" { } ]
          [ "v" "<Leader>F" "<cmd>lua vim.lsp.buf.range_formatting()<CR>" { } ]
        ];

        # Enable completion triggered by <c-x><c-o>
        opts.omnifunc = "v:lua.vim.lsp.omnifunc";

        on_attach = ./lspconfig-on_attach.lua;
      };
      plugins = [
        nvim-lspconfig
        lsp-status-nvim
      ];
      lua = [
        "require'lsp-status'.register_progress()"
      ];
    }
    {
      name = "vimtex";
      plugins = [ vimtex ];
      vars.tex_flavor = "latex";
    }
    {
      name = "colorscheme-and-more";
      vim = [
        "colorscheme gruvbox"
        (builtins.readFile ./init.vim)
      ];
    }
  ];
}
