{
  config,
  pkgs,
  lib,
  nix2nvimrc,
  ...
}:
let
  inherit (nix2nvimrc) luaExpr;
  inherit (config) hasLang;
in
{
  configs.lspconfig = {
    after = [
      "global"
      "lsp-status"
      "cmp"
    ];
    plugins = [ pkgs.vimPlugins.nvim-lspconfig ];
    lspconfig = {
      servers =
        let
          lang_server = {
            javascript.ts_ls.config = {
              # https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/ts_ls.lua#L59
              init_options = {
                plugins = [
                  {
                    name = "@vue/typescript-plugin";
                    location = "${pkgs.ck3dNvimPkgs.nvim-tsserver-vue-env}/node_modules/@vue/typescript-plugin";
                    languages = [
                      "javascript"
                      "typescript"
                      "vue"
                    ];
                  }
                ];
              };
              filetypes = [
                "javascript"
                "typescript"
                "vue"
              ];
            };
            bash.bashls = { };
            nix.nixd.config = {
              # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md#where-to-place-the-configuration
              settings.nixd.formatting.command = [ "nixfmt" ];
            };
            rust.rust_analyzer = { };
            yaml.yamlls = { };
            lua.lua_ls.config.settings.Lua = ./sumneko_lua.config.lua;
            xml.lemminx.config.filetypes = [ "xslt" ];
            python.pyright = { };
            json.jsonls = { };
            html.html = { };
            css.cssls = { };
            cpp.clangd = { };
            beancount.beancount.config.init_options = {
              root_file = "Root.beancount";
            };
            go.gopls = { };
            vue.volar = { };
            typst.tinymist = { };
            nickel.nickel_ls = { };
          };
        in
        builtins.foldl' (old: lang: old // lang_server.${lang}) { } (
          builtins.filter hasLang (builtins.attrNames lang_server)
        );

      capabilities = luaExpr "require'cmp_nvim_lsp'.default_capabilities(vim.tbl_extend('keep', vim.lsp.protocol.make_client_capabilities(), require'lsp-status'.capabilities))";

      keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
        [
          "n"
          "gD"
          (luaExpr "vim.lsp.buf.declaration")
          { desc = "Goto declaration"; }
        ]
        [
          "n"
          "gd"
          (luaExpr "vim.lsp.buf.definition")
          { desc = "Goto definition"; }
        ]
        [
          "n"
          "<Leader>wa"
          (luaExpr "vim.lsp.buf.add_workspace_folder")
          { desc = "Add workspace folder"; }
        ]
        [
          "n"
          "<Leader>wr"
          (luaExpr "vim.lsp.buf.remove_workspace_folder")
          { desc = "Remove workspace folder"; }
        ]
        [
          "n"
          "<Leader>wl"
          (luaExpr "function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end")
          { desc = "List workspace folder"; }
        ]
      ];

      on_attach = ./lspconfig-on_attach.lua;
    };

    env.PATH.values =
      let
        mapLangToPkgs = with pkgs; {
          javascript = [ ck3dNvimPkgs.nvim-tsserver-vue-env ];
          rust = [
            rust-analyzer
            # default config of rust-analyzer expects cargo:
            # https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/rust_analyzer.lua#L58
            cargo
            # since cargo depends on rustc, lets make it available:
            cargo.rustc
          ];
          nix = [
            nixd
            nixfmt-rfc-style
          ];
          # https://github.com/bash-lsp/bash-language-server?tab=readme-ov-file#dependencies
          bash = [
            bash-language-server
            shellcheck
            shfmt
          ];
          yaml = [ yaml-language-server ];
          lua = [ lua-language-server ];
          xml = [ lemminx ];
          python = [ pyright ];
          json = [ vscode-langservers-extracted ];
          css = [ vscode-langservers-extracted ];
          html = [ vscode-langservers-extracted ];
          cpp = [ clang-tools ];
          beancount = [ beancount-language-server ];
          go = [
            gopls
            go
          ];
          vue = [ ck3dNvimPkgs.nvim-tsserver-vue-env ];
          typst = [ tinymist typstyle typst ];
          nickel = [ nls nickel ];
        };
      in
      lib.flatten (
        map (lang: map (pkg: "${pkg}/bin") mapLangToPkgs.${lang}) (
          builtins.filter hasLang (builtins.attrNames mapLangToPkgs)
        )
      );
  };
}
