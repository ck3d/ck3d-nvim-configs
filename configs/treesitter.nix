{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.vimPlugins.nvim-treesitter) parsers queries;

  activeFor =
    set:
    lib.concatMap (
      lang:
      if set ? ${lang} then
        [ set.${lang} ]
      else if
        lib.elem lang [
          "plantuml"
        ]
      then
        [ ]
      else
        lib.warn "treesitter set does not contain ${lang}" [ ]
    ) config.languages;
in
{
  configs.treesitter = {
    plugins = activeFor parsers ++ activeFor queries;

    env.PATH.values = [ pkgs.tree-sitter ];
  };
}
