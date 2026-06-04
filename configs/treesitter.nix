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

        grammars' = lib.getAttrs (builtins.filter
          (
            type:
            if builtins.hasAttr type grammars then
              true
            # disable trace for following languages
            else if builtins.any (lang: type == lang) [ "tree-sitter-plantuml" ] then
              false
            else
              builtins.trace "no tree-sitter parser for language ${type} available" false
          )
          (
            map (lang: "tree-sitter-" + lang) (
              # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/ne/neovim-unwrapped/treesitter-parsers.nix
              lib.subtractLists [
                "c"
                "lua"
                "vim"
                "vimdoc"
                "query"
                "markdown"
              ] config.languages
            )
          )
        ) grammars;
      in
      lib.mapAttrs' (n: v: lib.nameValuePair (lib.removePrefix "tree-sitter-" n) "${v}/parser") grammars';

    env.PATH.values = [
      pkgs.tree-sitter
    ];
  };
}
