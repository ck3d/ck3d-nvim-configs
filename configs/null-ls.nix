{
  config,
  pkgs,
  lib,
  nix2nvimrc,
  ...
}:
let
  inherit (config) hasLang;
in
{
  configs.null-ls = {
    inherit (config.config.lspconfig) after;
    plugins = [ pkgs.vimPlugins.none-ls-nvim ];
    setup.args = {
      sources = map (s: nix2nvimrc.luaExpr ("require'null-ls.builtins'." + s)) (
        [ "code_actions.gitsigns" ]
        ++ lib.optional (builtins.any hasLang [
          "javascript"
          "markdown"
        ]) "formatting.prettier"
        ++ lib.optionals (hasLang "nix") [
          "code_actions.statix"
          "diagnostics.statix"
        ]
      );
      on_attach = ./lspconfig-on_attach.lua;
    };
    env.PATH.values = map (x: "${lib.getBin x}/bin") (
      lib.optional (hasLang "javascript") pkgs.nodePackages.prettier
      ++ lib.optional (hasLang "nix") pkgs.statix
    );
  };
}
