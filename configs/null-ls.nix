{
  config,
  pkgs,
  lib,
  nix2nvimrc,
  ...
}:
let
  inherit (config) hasLang;
  statixCfg = pkgs.writers.writeTOML "statix.yaml" {
    disabled = [
      "repeated_keys"
    ];
  };
in
{
  configs.null-ls = {
    inherit (config.config.lspconfig) after;
    plugins = [
      pkgs.vimPlugins.none-ls-nvim
      pkgs.vimPlugins.plenary-nvim
    ];
    setup.args = {
      sources = map (s: nix2nvimrc.luaExpr ("require'null-ls.builtins'." + s)) (
        lib.optional (builtins.any hasLang [
          "javascript"
          "markdown"
        ]) "formatting.prettier"
        ++ lib.optionals (hasLang "nix") [
          "code_actions.statix"
          "diagnostics.statix.with({ extra_args = { '--config', '${statixCfg}' }})"
        ]
      );
      on_attach = ./lspconfig-on_attach.lua;
    };
    env.PATH.values =
      lib.optional (hasLang "javascript") pkgs.prettier ++ lib.optional (hasLang "nix") pkgs.statix;
  };
}
