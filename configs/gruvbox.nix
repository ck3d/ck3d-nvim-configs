{ pkgs, ... }:
{
  configs.gruvbox = {
    after = [
      "global"
    ];
    plugins = [ pkgs.vimPlugins.gruvbox-nvim ];
    setup = { };
    vim = [ "colorscheme gruvbox" ];
  };
}
