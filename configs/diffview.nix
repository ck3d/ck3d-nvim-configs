{ config, pkgs, ... }:
{
  configs.diffview = {
    plugins = [ pkgs.vimPlugins.diffview-nvim ];
    # https://github.com/sindrets/diffview.nvim#configuration
    setup.args = {
      use_icons = config.configs ? nvim-web-devicons;
    };
  };
}
