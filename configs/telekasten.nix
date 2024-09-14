{ pkgs, nix2nvimrc, ... }:
{
  configs.telekasten = {
    after = [ "telescope" ];
    plugins = [ pkgs.vimPlugins.telekasten-nvim ];
    setup.args = {
      home = nix2nvimrc.luaExpr "vim.fn.expand('~/zettelkasten')";
    };
    keymaps = map (nix2nvimrc.toKeymap { }) [
      [
        "n"
        "<Leader>z"
        (nix2nvimrc.luaExpr "require'telekasten'.panel")
        {
          desc = "Telekasten panel";
        }
      ]
    ];
  };
}
