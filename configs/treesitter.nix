{
  config,
  pkgs,
  lib,
  ...
}:
{
  configs.treesitter = {
    treesitter.parsers =
      let
        # do not use pkgs.tree-sitter-grammars, the packages are not up to date
        # and it misses languages like jq, vimdoc, and xml
        grammars = pkgs.vimPlugins.nvim-treesitter.builtGrammars;

        # Exclude built-in parsers (https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ne/neovim-unwrapped/treesitter-parsers.nix)
        excluded = [
          "c"
          "lua"
          "vim"
          "vimdoc"
          "query"
          "markdown"
        ];

        languages = lib.subtractLists excluded config.languages;

        makeParserEntry =
          lang:
          let
            name = "tree-sitter-${lang}";
          in
          if grammars ? ${name} then
            [ (lib.nameValuePair lang "${grammars.${name}}/parser") ]
          else if lang == "plantuml" then
            [ ] # disable trace for plantuml
          else
            builtins.trace "no tree-sitter parser for language ${lang} available" [ ];
      in
      lib.listToAttrs (lib.concatMap makeParserEntry languages);

    env.PATH.values = [ pkgs.tree-sitter ];
  };
}
