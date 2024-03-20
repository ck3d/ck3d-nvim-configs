{ nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) luaExpr;
in
{
  configs.private-keymaps.keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
    [ "n" "<Leader>fd" (luaExpr "function() require'telescope.builtin'.git_files({cwd= '~/dotfiles/'}) end") { desc = "Find dotfiles file"; } ]
  ];
}
