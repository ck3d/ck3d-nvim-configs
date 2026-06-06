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

  langs = {
    bash = {
      servers.bashls = { };
      # https://github.com/bash-lsp/bash-language-server?tab=readme-ov-file#dependencies
      packages = [
        pkgs.bash-language-server
        pkgs.shellcheck
        pkgs.shfmt
      ];
    };
    beancount = {
      servers.beancount.config.init_options.root_file = "Root.beancount";
      packages = [ pkgs.beancount-language-server ];
    };
    cpp = {
      servers.clangd = { };
      packages = [ pkgs.clang-tools ];
    };
    css = {
      servers.cssls = { };
      packages = [ pkgs.vscode-langservers-extracted ];
    };
    go = {
      servers.gopls = { };
      packages = [
        pkgs.gopls
        pkgs.go
      ];
    };
    html = {
      servers.html = { };
      packages = [ pkgs.vscode-langservers-extracted ];
    };
    javascript = {
      servers.ts_ls.config = { };
      packages = [
        pkgs.typescript-language-server
        pkgs.nodejs
        pkgs.bun
        pkgs.tsx
      ];
    };
    json = {
      servers.jsonls = { };
      packages = [ pkgs.vscode-langservers-extracted ];
    };
    lua = {
      servers.lua_ls.config.settings.Lua = ./sumneko_lua.config.lua;
      packages = [
        pkgs.lua-language-server
      ]
      ++ lib.optional (config ? wrapper.pkg.lua) config.wrapper.pkg.lua;
    };
    nickel = {
      servers.nickel_ls = { };
      packages = [
        pkgs.nls
        pkgs.nickel
      ];
    };
    nix = {
      servers.nixd.config = {
        # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md#where-to-place-the-configuration
        settings.nixd.formatting.command = [ "nixfmt" ];
      };
      packages = [
        pkgs.nixd
        pkgs.nixfmt
      ];
    };
    python = {
      servers.pyright = { };
      packages = [
        pkgs.pyright
        pkgs.python3
      ];
    };
    rust = {
      servers.rust_analyzer = { };
      # default config of rust-analyzer expects cargo:
      # https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/rust_analyzer.lua#L58
      packages = [
        pkgs.rust-analyzer
        pkgs.cargo
        # since cargo depends on rustc, lets make it available:
        pkgs.cargo.rustc
      ];
    };
    typst = {
      servers.tinymist = { };
      packages = [
        pkgs.tinymist
        pkgs.typstyle
        pkgs.typst
      ];
    };
    xml = {
      servers.lemminx.config.filetypes = [ "xslt" ];
      packages = [ pkgs.lemminx ];
    };
    yaml = {
      servers.yamlls = { };
      packages = [ pkgs.yaml-language-server ];
    };
  };

  enabledLangs = lib.filterAttrs (name: _: hasLang name) langs;
in
{
  configs.lspconfig = {
    after = [
      "global"
      "blink.cmp"
    ];
    plugins = [ pkgs.vimPlugins.nvim-lspconfig ];
    lspconfig = {
      servers = lib.concatMapAttrs (_: lang: lang.servers) enabledLangs;

      capabilities = luaExpr "require'blink.cmp'.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())";

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
      ];

      on_attach = ./lspconfig-on_attach.lua;
    };

    env.PATH.values = lib.concatMap (lang: lang.packages) (lib.attrValues enabledLangs);
  };
}
