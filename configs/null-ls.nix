{ config, pkgs, lib, nix2nvimrc, ... }:
let
  inherit (config) hasLang;
in
{
  configs.null-ls = {
    inherit (config.config.lspconfig) after;
    plugins = [ pkgs.vimPlugins.none-ls-nvim ];
    setup.args = {
      sources = map (s: nix2nvimrc.luaExpr ("require'null-ls.builtins'." + s)) (
        [
          "code_actions.gitsigns"
          "formatting.prettier.with({command = '${pkgs.nodePackages.prettier}/bin/prettier', disabled_filetypes = {'vue'}})"
          "diagnostics.write_good.with({command = '${pkgs.nodePackages.write-good}/bin/write-good'})"
          "diagnostics.proselint.with({command = '${pkgs.proselint}/bin/proselint'})"
        ]
        ++ lib.optionals (hasLang "nix") [
          "code_actions.statix.with({command = '${pkgs.statix}/bin/statix'})"
          "diagnostics.statix.with({command = '${pkgs.statix}/bin/statix'})"
        ]
      );
      on_attach = ./lspconfig-on_attach.lua;
    };
  };
}
