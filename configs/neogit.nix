{ config, pkgs, ... }:
{
  configs.neogit = {
    plugins = [
      pkgs.vimPlugins.neogit
      pkgs.vimPlugins.plenary-nvim
    ];
    setup.args = {
      integrations.diffview = config.config ? diffview;
      integrations.telescope = config.config ? telescope;
    };
  };
}
