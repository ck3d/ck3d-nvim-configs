{
  config,
  pkgs,
  lib,
  ...
}:
let
  # do not use pkgs.tree-sitter-grammars, the packages are not up to date
  # and it misses languages like jq, vimdoc, and xml
  grammars = pkgs.vimPlugins.nvim-treesitter.builtGrammars;

  supportedLanguages = lib.filter (
    lang:
    if grammars ? ${lang} then
      true
    else if lang == "plantuml" then
      false # disable trace for plantuml
    else
      builtins.trace "no tree-sitter parser for language ${lang} available" false
  ) config.languages;
in
{
  configs.treesitter = {
    treesitter.parsers = lib.genAttrs supportedLanguages (lang: "${grammars.${lang}}/parser");

    env.PATH.values = [ pkgs.tree-sitter ];
  };
}
