{ pkgs, ... }:
{
  configs.gruvbox = {
    after = [ "global" "toggleterm" ];
    plugins = [ pkgs.vimPlugins.gruvbox-nvim ];
    setup = { };
    vim = [ "colorscheme gruvbox" ];
  };
}
