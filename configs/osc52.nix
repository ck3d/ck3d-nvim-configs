{ pkgs, nix2nvimrc, ... }:
{
  configs.osc52 = {
    after = [ "leader" ];
    plugins = [ pkgs.vimPlugins.nvim-osc52 ];
    setup = { };
    keymaps = map (nix2nvimrc.toKeymap { }) [
      [
        "n"
        "<Leader>y"
        (nix2nvimrc.luaExpr "require'osc52'.copy_operator")
        { expr = true; desc = "Yank to clipboard"; }
      ]
      [
        "x"
        "<Leader>y"
        (nix2nvimrc.luaExpr "require'osc52'.copy_visual")
        { desc = "Yank to clipboard"; }
      ]
    ];
  };
}
