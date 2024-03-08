{ pkgs, nix2nvimrc, ... }:
{
  configs.outline = {
    plugins = [ pkgs.ck3dNvimPkgs.outline-nvim ];
    setup = { };
    keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
      [ "n" "<C-o>" "<Cmd>Outline<CR>" { desc = "Toggle Outline"; } ]
    ];
  };
}
