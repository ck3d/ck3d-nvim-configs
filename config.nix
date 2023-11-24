{ config, pkgs, lib, nix2nvimrc, ... }:
let
  inherit (pkgs) vimPlugins ck3dNvimPkgs;
  inherit (nix2nvimrc) toLuaFn luaExpr;
  hasLang = lang: builtins.any (i: i == lang) config.languages;
  keymap_silent = nix2nvimrc.toKeymap { silent = true; };
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
  ];

  configs = {
    leader.vars.mapleader = " ";

    neovide.vars = {
      neovide_cursor_antialiasing = true;
      neovide_cursor_vfx_mode = "pixiedust";
    };

    global = {
      after = [ "leader" ];
      plugins = with vimPlugins; [
        vim-speeddating # CTRL-A/CTRL-X on dates

        registers-nvim
        # TODO: test neuron-vim
        # TODO: test rust-vim
      ]
      ++ lib.optional (hasLang "plantuml") plantuml-syntax
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
        guifont = "Monolisa:h9";
        signcolumn = "yes";
        splitbelow = true;
        splitright = true;
        updatetime = 300;
        formatoptions = luaExpr "vim.o.formatoptions .. 'n'";
        background = "light";
        completeopt = "menu,menuone,noselect";
      };
      keymaps = map keymap_silent [
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
      vim = [ ./init.vim ];
    };

    gitsigns = {
      plugins = [ vimPlugins.gitsigns-nvim ];
      setup.args = {
        current_line_blame = true;
        current_line_blame_opts = {
          ignore_whitespace = true;
        };
        on_attach = ./gitsigns-on_attach.lua;
      };
    };

    nvim-tree = {
      plugins = [ vimPlugins.nvim-tree-lua ];
      setup.args = {
        # https://github.com/ahmedkhalf/project.nvim
        sync_root_with_cwd = true;
        respect_buf_cwd = true;
        update_focused_file = {
          enable = true;
          update_root = true;
        };
      };
      keymaps = map keymap_silent [
        [ "n" "<C-n>" "<Cmd>NvimTreeToggle<CR>" { } ]
      ];
    };

    which-key = {
      plugins = [ vimPlugins.which-key-nvim ];
      setup = { };
    };

    Comment = {
      plugins = [ vimPlugins.comment-nvim ];
      setup = { };
    };

    toggleterm = {
      plugins = [ vimPlugins.toggleterm-nvim ];
      setup.args = {
        open_mapping = "<c-t>";
        shade_terminals = false;
      };
    };

    bufferline = {
      after = [ "leader" ];
      plugins = [ vimPlugins.bufferline-nvim ];
      setup = { };
      keymaps = map keymap_silent [
        [ "n" "<Leader>b" "<Cmd>BufferLinePick<CR>" { } ]
      ];
    };

    project_nvim = {
      after = [ "telescope" ];
      plugins = [ vimPlugins.project-nvim ];
      lua = [
        "require'telescope'.load_extension('projects')"
      ];
      setup.args = {
        patters = [ ".envrc" ];
      };
      keymaps = map keymap_silent [
        [ "n" "<Leader>fp" "<Cmd>Telescope projects<CR>" { } ]
      ];
    };

    telescope = {
      after = [ "leader" ];
      plugins = [
        vimPlugins.telescope-fzy-native-nvim
        vimPlugins.telescope-file-browser-nvim
        vimPlugins.telescope-ui-select-nvim
      ];
      setup = { };
      lua = map (a: toLuaFn "require'telescope'.load_extension" [ a ]) [
        "fzy_native"
        "file_browser"
        "ui-select"
      ];
      # https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
      keymaps = map keymap_silent [
        [ "n" "<Leader>ff" (luaExpr "require'telescope.builtin'.find_files") { desc = "Find file"; } ]
        [ "n" "<Leader>fF" (luaExpr "require'telescope.builtin'.git_files") { desc = "Find git file"; } ]
        [ "n" "<Leader>fg" (luaExpr "require'telescope.builtin'.live_grep") { desc = "Find line"; } ]
        [ "n" "<Leader>fb" (luaExpr "require'telescope.builtin'.buffers") { desc = "Find buffer"; } ]
        [ "n" "<Leader>fh" (luaExpr "require'telescope.builtin'.help_tags") { desc = "Find help tag"; } ]
        [ "n" "<Leader>ft" "<Cmd>Telescope file_browser<CR>" { desc = "Find file via browser"; } ]
        [ "n" "<Leader>fT" (luaExpr "require'telescope.builtin'.tags") { desc = "Find help tag"; } ]
        [ "n" "<Leader>fc" (luaExpr "require'telescope.builtin'.commands") { desc = "Find command"; } ]
        [ "n" "<Leader>fq" (luaExpr "require'telescope.builtin'.quickfix") { desc = "Find in quickfix"; } ]
        [ "n" "<Leader>fd" (luaExpr "function() require'telescope.builtin'.git_files({cwd= '~/dotfiles/'}) end") { desc = "Find dotfiles file"; } ]
        [ "n" "<Leader>fr" (luaExpr "function() require'telescope.builtin'.find_files({cwd= '%:h'}) end") { desc = "Find file relative"; } ]
        [ "n" "<Leader>gs" (luaExpr "require'telescope.builtin'.git_status") { desc = "Git status"; } ]
        [ "n" "<Leader>wo" (luaExpr "require'telescope.builtin'.lsp_document_symbols") { desc = "Find LSP doc. symbol"; } ]
      ];
    };

    treesitter-context = {
      plugins = [ vimPlugins.nvim-treesitter-context ];
      setup = { };
    };

    nvim-treesitter = {
      plugins = with vimPlugins; [
        nvim-treesitter
        playground
        nvim-treesitter-textobjects
      ];
      setup.modulePath = "nvim-treesitter.configs";
      setup.args = {
        highlight.enable = true;
        incremental_selection.enable = true;
        textobjects.enable = true;
        playground.enable = true;

        # nvim-treesitter-textobjects
        textobjects.select = {
          enable = true;
          lookahead = true;
          keymaps = {
            af = "@function.outer";
            "if" = "@function.inner";
            ac = "@class.outer";
            ic = { query = "@class.inner"; desc = "Select inner part of a class region"; };
          };
        };
      };

      lua =
        let
          gen-tree-sitter-package = language: src: {
            name = language;
            value = pkgs.callPackage (pkgs.path + "/pkgs/development/tools/parsing/tree-sitter/grammar.nix") { } {
              inherit (pkgs.tree-sitter) version;
              inherit language src;
            };
          };
          grammars = pkgs.tree-sitter.builtGrammars
            // (builtins.listToAttrs [
            (gen-tree-sitter-package "jq" (pkgs.fetchFromGitHub {
              owner = "flurie";
              repo = "tree-sitter-jq";
              rev = "13990f530e8e6709b7978503da9bc8701d366791";
              hash = "sha256-pek2Vg1osMYAdx6DfVdZhuIDb26op3i2cfvMrf5v3xY=";
            }))
            (gen-tree-sitter-package "lua" (pkgs.fetchFromGitHub {
              owner = "MunifTanjim";
              repo = "tree-sitter-lua";
              rev = "v0.0.19";
              hash = "sha256-w+WVQHPiS/xyRz0obdJoUHZ7QzIDAvgtSzmE98yDORY=";
            }))
            (gen-tree-sitter-package "c" (pkgs.fetchFromGitHub {
              owner = "tree-sitter";
              repo = "tree-sitter-c";
              rev = "v0.20.5";
              hash = "sha256-5n9ZnslpUWyusWTo+AqJiPGB64NB0rTbc2rtfByPUC8=";
            }))
          ]);
          grammars' = lib.getAttrs
            (builtins.filter
              (type: builtins.hasAttr type grammars)
              config.languages)
            grammars;
        in
        map
          (n: toLuaFn
            "vim.treesitter.language.require_language"
            [ n "${grammars'.${n}}/parser" ])
          (builtins.attrNames grammars');
    };

    lualine = {
      after = [ "lsp-status" ];
      plugins = [ vimPlugins.lualine-nvim ];
      setup.args = {
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            "branch"
            (luaExpr "{'diagnostics', sources={'nvim_diagnostic'}}")
          ];
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
      after = [ "lspconfig" ];
      plugins = [ vimPlugins.lsp_extensions-nvim ];
      vim = [
        "autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }"
      ];
    };

    cmp = {
      plugins = with vimPlugins; [
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-nvim-lua
        cmp-treesitter
        cmp-nvim-lsp
        cmp-spell
        cmp-nvim-tags
        cmp-vsnip

        vim-vsnip
      ];
      setup.args = ./cmp_setup_args.lua;
    };

    ibl = {
      plugins = [ vimPlugins.indent-blankline-nvim ];
      setup.args = {
        indent.char = "⎸";
        enabled = false;
      };
      vim = lib.optional (hasLang "yaml") "autocmd FileType yaml IBLEnable";
    };

    leap = {
      plugins = [ vimPlugins.leap-nvim ];
      lua = [
        "require'leap'.add_default_mappings()"
      ];
    };

    null-ls = {
      inherit (config.config.lspconfig) after;
      plugins = [ vimPlugins.none-ls-nvim ];
      setup.args = {
        sources = map (s: luaExpr ("require'null-ls.builtins'." + s)) (
          [
            "code_actions.gitsigns"
            "formatting.prettier.with({command = '${pkgs.nodePackages.prettier}/bin/prettier', disabled_filetypes = {'vue'}})"
            "diagnostics.write_good.with({command = '${pkgs.nodePackages.write-good}/bin/write-good'})"
            "diagnostics.proselint.with({command = '${pkgs.proselint}/bin/proselint'})"
          ]
          ++ lib.optionals (hasLang "bash") [
            "code_actions.shellcheck.with({command = '${pkgs.shellcheck}/bin/shellcheck'})"
            "diagnostics.shellcheck.with({command = '${pkgs.shellcheck}/bin/shellcheck'})"
          ]
          ++ lib.optional (hasLang "lua")
            "formatting.lua_format.with({command = '${pkgs.luaformatter}/bin/lua-format'})"
          ++ lib.optionals (hasLang "nix") [
            "code_actions.statix.with({command = '${pkgs.statix}/bin/statix'})"
            "diagnostics.statix.with({command = '${pkgs.statix}/bin/statix'})"
          ]
        );
        on_attach = ./lspconfig-on_attach.lua;
      };
    };

    lspconfig = {
      after = [
        "global"
        "lsp-status"
        "cmp"
      ];
      plugins = [ vimPlugins.nvim-lspconfig ];
      lspconfig = {
        servers =
          let
            lang_server = {
              javascript.tsserver.pkg = pkgs.nodePackages.typescript-language-server;
              bash.bashls.pkg = pkgs.nodePackages.bash-language-server;
              nix.nixd = {
                pkg = pkgs.nixd;
                # nixd ignores following configuration, but it should work, see:
                # https://github.com/nix-community/nixd/blob/e8f144ca50fe71e74d247e5308ae7ce122f0a0e6/nixd/tools/nixd/test/workspace-configuration.md?plain=1#L75
                # config.settings.formatting.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
                # Workaround: Since I do not know how to extend environment
                # variable PATH from Lua, we have to extend PATH in makeWrapper of NVim.
              };
              rust.rust_analyzer.pkg = pkgs.rust-analyzer;
              yaml.yamlls.pkg = pkgs.nodePackages.yaml-language-server;
              lua.lua_ls = {
                pkg = pkgs.sumneko-lua-language-server;
                config = {
                  cmd = [ "lua-language-server" ];
                  settings.Lua = ./sumneko_lua.config.lua;
                };
              };
              xml.lemminx = {
                pkg = ck3dNvimPkgs.lemminx;
                config = {
                  cmd = [ "lemminx" ];
                  filetypes = [ "xslt" ];
                };
              };
              python.pyright.pkg = pkgs.nodePackages.pyright;
              # dhall-lsp-server is broken
              #dhall.dhall_lsp_server.pkg = pkgs.dhall-lsp-server;
              json.jsonls = {
                pkg = pkgs.nodePackages.vscode-json-languageserver-bin;
                config.cmd = [ "json-languageserver" "--stdio" ];
              };
              cpp.clangd.pkg = pkgs.llvmPackages_13.clang-unwrapped;
              beancount.beancount = {
                pkg = pkgs.beancount-language-server;
                config = {
                  # TODO: Check why language server failes:
                  # Client 1 quit with exit code 101 and signal 0
                  init_options.journal_file = "Main.beancount";
                  root_dir = luaExpr "require'lspconfig.util'.root_pattern('default.nix')";
                };
              };
              go.gopls.pkg = pkgs.gopls;
              vue.volar.pkg = pkgs.ck3dNvimPkgs.volar;
            };
          in
          builtins.foldl'
            (old: lang: old // lang_server.${lang})
            { }
            (builtins.filter hasLang (builtins.attrNames lang_server));

        capabilities = luaExpr "require'cmp_nvim_lsp'.default_capabilities(vim.tbl_extend('keep', vim.lsp.protocol.make_client_capabilities(), require'lsp-status'.capabilities))";

        keymaps = map keymap_silent [
          [ "n" "gD" (luaExpr "vim.lsp.buf.declaration") { desc = "Goto declaration"; } ]
          [ "n" "gd" (luaExpr "vim.lsp.buf.definition") { desc = "Goto definition"; } ]
          [ "n" "K" (luaExpr "vim.lsp.buf.hover") { desc = "Show hover"; } ]
          [ "n" "gi" (luaExpr "vim.lsp.buf.implementation") { desc = "Goto implementation"; } ]
          [ "n" "<C-k>" (luaExpr "vim.lsp.buf.signature_help") { desc = "Show signature help"; } ]
          [ "n" "<Leader>wa" (luaExpr "vim.lsp.buf.add_workspace_folder") { desc = "Add workspace folder"; } ]
          [ "n" "<Leader>wr" (luaExpr "vim.lsp.buf.remove_workspace_folder") { desc = "Remove workspace folder"; } ]
          [ "n" "<Leader>wl" (luaExpr "function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end") { desc = "List workspace folder"; } ]
          [ "n" "<Leader>D" (luaExpr "vim.lsp.buf.type_definition") { desc = "Goto definition"; } ]
          [ "n" "<Leader>rn" (luaExpr "vim.lsp.buf.rename") { desc = "Rename"; } ]
          [ "n" "<Leader>ca" (luaExpr "vim.lsp.buf.code_action") { desc = "Code actions"; } ]
          [ "n" "gr" (luaExpr "vim.lsp.buf.references") { desc = "Select codGoto definition"; } ]
        ];

        on_attach = ./lspconfig-on_attach.lua;
      };
    };

    lsp-status = {
      plugins = [ vimPlugins.lsp-status-nvim ];
      lua = [
        "require'lsp-status'.register_progress()"
      ];
    };

    diffview = {
      plugins = [ vimPlugins.diffview-nvim ];
      # https://github.com/sindrets/diffview.nvim#configuration
      setup.args = {
        use_icons = config.configs ? nvim-web-devicons;
      };
    };

    neogit = {
      plugins = [ vimPlugins.neogit ];
      setup.args = {
        integrations.diffview = config.config ? diffview;
        integrations.telescope = config.config ? telescope;
      };
    };

    osc52 = {
      plugins = [ vimPlugins.nvim-osc52 ];
      setup.args = { };
      keymaps = map (nix2nvimrc.toKeymap { }) [
        [ "n" "<Leader>y" (luaExpr "require'osc52'.copy_operator") { expr = true; desc = "Yank to clipboard"; } ]
        [ "x" "<Leader>y" (luaExpr "require'osc52'.copy_visual") { desc = "Yank to clipboard"; } ]
      ];
    };

    gruvbox = {
      after = [ "global" "toggleterm" ];
      plugins = [ vimPlugins.gruvbox-nvim ];
      setup = { };
      vim = [ "colorscheme gruvbox" ];
    };

    nvim-web-devicons = {
      plugins = [ vimPlugins.nvim-web-devicons ];
      setup = { };
    };

    trouble = {
      after = [ "leader" ];
      plugins = [ vimPlugins.trouble-nvim ];
      setup.args = {
        icons = config.configs ? nvim-web-devicons;
      };
      keymaps = map keymap_silent [
        [ "n" "<Leader>xx" "<Cmd>TroubleToggle<CR>" { desc = "Toggle trouble list"; } ]
        [ "n" "gR" "<Cmd>TroubleToggle lsp_references<CR>" { desc = "Toggle lsp reference trouble list"; } ]
      ];
    };

    symbols_outline = {
      plugins = [ vimPlugins.symbols-outline-nvim ];
      vars.symbols_outline = { };
      keymaps = map keymap_silent [
        [ "n" "<C-o>" "<Cmd>SymbolsOutline<CR>" { desc = "Toggle symbols outline"; } ]
      ];
    };

    nvim-surround = {
      plugins = [ vimPlugins.nvim-surround ];
      setup = { };
    };
  }
  // lib.optionalAttrs (hasLang "latex") {
    vimtex = {
      plugins = [ vimPlugins.vimtex ];
      vars.tex_flavor = "latex";
    };
  }
  // lib.optionalAttrs (hasLang "lua") {
    luapad = {
      plugins = [ vimPlugins.nvim-luapad ];
      setup = { };
    };
  }
  ;
}
