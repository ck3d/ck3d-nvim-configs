{ config, pkgs, lib, nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) luaExpr;
  hasLang = lang: builtins.any (i: i == lang) config.languages;
  silent_noremap = nix2nvimrc.toKeymap { noremap = true; silent = true; };
in
{
  imports = [
    {
      options = with lib; {
        languages = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };
    }
    #./devicons.nix
  ];

  configs = {
    ${builtins.concatStringsSep "-" ([ "languages" ] ++ config.languages)} = {
      treesitter.languages = builtins.filter
        (type: builtins.hasAttr "tree-sitter-${type}" config.treesitter.grammars)
        config.languages;
    };
    global = {
      after = [ "global" ];
      plugins = with pkgs.vimPlugins; [
        # TODO: test:
        # https://github.com/TimUntersberger/neogit
        fugitive

        neoformat
        surround
        vim-speeddating # CTRL-A/CTRL-X on dates

        registers-nvim
        # TODO: test neuron-vim
        # TODO: test rust-vim
      ]
      ++ lib.optional (hasLang "beancount" && pkgs.stdenv.hostPlatform.system != "aarch64-darwin") vim-beancount
      ++ lib.optional (hasLang "jq") jq-vim
      ++ lib.optional (hasLang "lua") pkgs.ck3dNvimPkgs.vimPlugins.nvim-luapad
      ++ lib.optional (hasLang "graphql") vim-graphql
      ++ lib.optional (hasLang "plantuml") plantuml-syntax
      ;
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
        formatoptions = luaExpr "vim.o.formatoptions .. 'n'";
        background = "light";
        completeopt = "menu,menuone,noselect";
      };
      keymaps = map silent_noremap [
        [ "" "<C-h>" "<C-w>h" { } ]
        [ "" "<C-j>" "<C-w>j" { } ]
        [ "" "<C-k>" "<C-w>k" { } ]
        [ "" "<C-l>" "<C-w>l" { } ]
        [ "n" "<F2>" "<Cmd>read !uuidgen<CR>" { } ]
        [ "n" "<Leader>cd" "<Cmd>lcd %:p:h<CR>" { } ]
        [ "n" "<Leader>n" "<Cmd>bnext<CR>" { } ]
        [ "n" "<Leader>p" "<Cmd>bprevious<CR>" { } ]
        [ "n" "n" "nzz" { } ]
        [ "n" "N" "Nzz" { } ]
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
    };
    gitsigns = {
      plugins = with pkgs.vimPlugins; [ gitsigns-nvim ];
      setup = { };
    };
    nvim-tree = {
      plugins = with pkgs.vimPlugins; [ nvim-tree-lua ];
      setup = { };
      keymaps = map silent_noremap [
        [ "n" "<C-n>" "<Cmd>NvimTreeToggle<CR>" { } ]
      ];
    };
    which-key = {
      plugins = with pkgs.vimPlugins; [ which-key-nvim ];
      setup = { };
    };
    Comment = {
      plugins = with pkgs.vimPlugins; [ comment-nvim ];
      setup = { };
    };
    toggleterm = {
      plugins = with pkgs.vimPlugins; [ toggleterm-nvim ];
      setup.args = {
        open_mapping = "<c-t>";
        shade_terminals = false;
      };
    };
    bufferline = {
      plugins = with pkgs.vimPlugins; [ bufferline-nvim ];
      setup = { };
      keymaps = map silent_noremap [
        [ "n" "gb" "<Cmd>BufferLinePick<CR>" { } ]
      ];
    };
    vim-rooter = {
      plugins = with pkgs.vimPlugins; [ vim-rooter ];
      vars.rooter_patterns = [
        ".git"
        "Cargo.toml"
        "flake.nix"
        ".lua-format"
        ".envrc"
      ];
    };
    telescope = {
      plugins = with pkgs.vimPlugins; [ telescope-nvim plenary-nvim popup-nvim ];
      # https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
      setup.args.defaults = {
        file_sorter = luaExpr "require'telescope.sorters'.get_fzy_sorter";
        generic_sorter = luaExpr "require'telescope.sorters'.get_fzy_sorter";
      };
      keymaps = map silent_noremap [
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
        [ "n" "<Leader>fa" "<Cmd>lua require'telescope.builtin'.lsp_code_actions()<CR>" { } ]
        [ "n" "<Leader>fA" "<Cmd>lua require'telescope.builtin'.lsp_range_code_actions()<CR>" { } ]
      ];
    };
    nvim-treesitter = {
      plugins = with pkgs.vimPlugins; [ nvim-treesitter playground ];
      setup.modulePath = "nvim-treesitter.configs";
      setup.args = {
        highlight.enable = true;
        incremental_selection.enable = true;
        textobjects.enable = true;
        playground.enable = true;
      };
    };
    lualine = {
      after = [ "lsp-status" ];
      plugins = with pkgs.vimPlugins; [ lualine-nvim ];
      setup.args = {
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" (luaExpr "{'diagnostics', sources={'nvim_lsp'}}") ];
          lualine_c = [ (luaExpr "{'filename', path = 1}") ];
          lualine_x = [
            "require'lsp-status'.status()"
            "diff"
            "filetype"
            "b:toggle_number"
          ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
        options = { theme = "gruvbox_${config.opt.background}"; };
      };
    };
    lsp_extensions = {
      after = [ "nix-lspconfig" ];
      plugins = with pkgs.vimPlugins; [ lsp_extensions-nvim ];
      vim = [
        "autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }"
      ];
    };
    cmp = {
      plugins = with pkgs.vimPlugins; [
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
      setup.args = {
        snippet = {
          expand = luaExpr "function(args) vim.fn['vsnip#anonymous'](args.body) end";
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
    };
    indentLine = {
      plugins = with pkgs.vimPlugins; [ indentLine ];
      vars.indentLine_enabled = 0;
      vars.indentLine_char = "⎸";
      vim = lib.optional (hasLang "yaml") "autocmd FileType yaml IndentLinesEnable";
    };
    lightspeed = {
      plugins = with pkgs.vimPlugins; [ lightspeed-nvim ];
      setup = { };
    };
    null-ls = {
      after = [ "gitsigns" ];
      plugins = with pkgs.vimPlugins; [
        (null-ls-nvim.overrideAttrs (s: {
          src = pkgs.fetchFromGitHub {
            owner = "jose-elias-alvarez";
            repo = "null-ls.nvim";
            rev = "73420db2b58408a60a19024be3c14b0eba8413fe";
            sha256 = "sha256-g2R34Bsx2lYNwJqIB5f8p43YF5P7l6RvQ92k5ntTVc4=";
          };
        }))
      ];
      setup.function = "config";
      setup.args = {
        sources = map (s: luaExpr ("require'null-ls.builtins'." + s)) (
          [
            "formatting.prettier.with({command = '${pkgs.nodePackages.prettier}/bin/prettier'})"
          ]
          ++ lib.optionals (hasLang "bash") [
            "code_actions.shellcheck.with({command = '${pkgs.shellcheck}/bin/shellcheck'})"
            "diagnostics.shellcheck.with({command = '${pkgs.shellcheck}/bin/shellcheck'})"
          ]
          ++ lib.optional (hasLang "lua" && pkgs.stdenv.hostPlatform.system != "aarch64-darwin")
            "formatting.lua_format.with({command = '${pkgs.luaformatter}/bin/lua-format'})"
        );
      };
    };
    nix-lspconfig = {
      after = [
        "global"
        "lsp-status"
        "null-ls"
      ];
      lspconfig = {
        servers =
          let
            lang_server = {
              javascript.tsserver.pkg = pkgs.nodePackages.typescript-language-server;
              bash.bashls.pkg = pkgs.nodePackages.bash-language-server;
              nix.rnix.pkg = pkgs.rnix-lsp;
              rust.rust_analyzer.pkg = pkgs.rust-analyzer;
              yaml.yamlls.pkg = pkgs.nodePackages.yaml-language-server;
            }
            // lib.optionalAttrs (pkgs.stdenv.hostPlatform.system != "aarch64-darwin") {
              xml.lemminx = {
                pkg = pkgs.ck3dNvimPkgs.lemminx;
                config = {
                  cmd = [ "lemminx" ];
                  filetypes = [ "xslt" ];
                };
              };
              lua.sumneko_lua = {
                pkg = pkgs.sumneko-lua-language-server;
                config = {
                  cmd = [ "lua-language-server" ];
                  settings.Lua = ./sumneko_lua.config.lua;
                };
              };
            };
          in
          builtins.foldl'
            (old: lang: old // lang_server.${lang})
            {
              null-ls.pkg = null;
            }
            (builtins.filter hasLang (builtins.attrNames lang_server));

        capabilities = luaExpr "require'cmp_nvim_lsp'.update_capabilities(vim.tbl_extend('keep', vim.lsp.protocol.make_client_capabilities(), require'lsp-status'.capabilities))";

        keymaps = map silent_noremap [
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
    };
    lsp-status = {
      plugins = with pkgs.vimPlugins; [ lsp-status-nvim ];
      lua = [
        "require'lsp-status'.register_progress()"
      ];
    };
    colorscheme-and-more = {
      after = [ "global" "toggleterm" ];
      plugins = with pkgs.vimPlugins; [
        gruvbox-nvim
        lush-nvim
      ];
      vim = [
        "colorscheme gruvbox"
        ./init.vim
      ];
    };
  }
  // lib.optionalAttrs (hasLang "tex") {
    vimtex = {
      plugins = with pkgs.vimPlugins; [ vimtex ];
      vars.tex_flavor = "latex";
    };
  };
}
