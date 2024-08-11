{ pkgs, nix2nvimrc, ... }:
{
  configs.outline = {
    plugins = [ pkgs.vimPlugins.outline-nvim ];
    setup = { };
    keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
      [
        "n"
        "<C-o>"
        "<Cmd>Outline<CR>"
        { desc = "Toggle Outline"; }
      ]
    ];
  };
}
