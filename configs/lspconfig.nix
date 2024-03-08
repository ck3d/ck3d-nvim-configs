{ config, pkgs, lib, nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) luaExpr;
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
            javascript.tsserver.pkg = pkgs.nodePackages.typescript-language-server;
            typescript.tsserver.pkg = pkgs.nodePackages.typescript-language-server;
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
              pkg = pkgs.lemminx;
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
            vue.volar.pkg = pkgs.nodePackages.volar;
          };
        in
        builtins.foldl'
          (old: lang: old // lang_server.${lang})
          { }
          (builtins.filter config.hasLang (builtins.attrNames lang_server));

      capabilities = luaExpr "require'cmp_nvim_lsp'.default_capabilities(vim.tbl_extend('keep', vim.lsp.protocol.make_client_capabilities(), require'lsp-status'.capabilities))";

      keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
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
}
