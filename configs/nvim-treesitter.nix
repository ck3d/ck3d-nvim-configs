{ config, pkgs, lib, nix2nvimrc, ... }:
{
  configs.nvim-treesitter = {
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      playground
      nvim-treesitter-textobjects
    ];
    setup.modulePath = "nvim-treesitter.configs";
    setup.args = {
      highlight.enable = true;
      incremental_selection.enable = true;
      textobjects.enable = true;
      playground.enable = true;

      # nvim-treesitter-textobjects
      textobjects.select = {
        enable = true;
        lookahead = true;
        keymaps = {
          af = "@function.outer";
          "if" = "@function.inner";
          ac = "@class.outer";
          ic = { query = "@class.inner"; desc = "Select inner part of a class region"; };
        };
      };
    };

    treesitter.parsers =
      let
        grammars = pkgs.tree-sitter-grammars
          //
          {
            inherit (pkgs.vimPlugins.nvim-treesitter.builtGrammars)
              # following parsers from tree-sitter-grammars are not available
              tree-sitter-jq
              tree-sitter-vimdoc
              tree-sitter-dhall
              tree-sitter-xml
              # following parsers from tree-sitter-grammars raises runtime errors
              tree-sitter-bash
              ;
          };
        grammars' = lib.getAttrs
          (builtins.filter
            (type:
              if builtins.hasAttr type grammars
              then true
              else builtins.trace "no tree-sitter parser for language ${type} availble" false)
            (map
              (lang: "tree-sitter-" + lang)
              (config.languages
                # garantie mandatory parsers, see also
                # https://github.com/NixOS/nixpkgs/pull/227159
                ++ [ "c" "lua" "vim" "vimdoc" "query" ])))
          grammars;
      in
      lib.mapAttrs'
        (n: v: lib.nameValuePair
          (lib.removePrefix "tree-sitter-" n)
          "${v}/parser")
        grammars';
  };
}
