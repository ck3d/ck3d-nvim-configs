{ pkgs, nix2nvimrc, ... }:
{
  configs.markview = {
    plugins = [ pkgs.vimPlugins.markview-nvim ];
    setup.args = {
      # https://github.com/OXY2DEV/markview.nvim/wiki/Preview
      preview.enable = false;
    };
    keymaps = map (nix2nvimrc.toKeymap { }) [
      [
        "n"
        "<Leader>M"
        "<Cmd>Markview<CR>"
        {
          desc = "Toggle Markview";
        }
      ]
    ];
  };
}
