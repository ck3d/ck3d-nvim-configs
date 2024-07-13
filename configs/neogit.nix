{ config, pkgs, ... }:
{
  configs.neogit = {
    plugins = [ pkgs.vimPlugins.neogit ];
    setup.args = {
      integrations.diffview = config.config ? diffview;
      integrations.telescope = config.config ? telescope;
    };
  };
}
