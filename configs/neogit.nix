{ config, pkgs, ... }:
{
  configs.neogit = {
    plugins = [
      pkgs.vimPlugins.neogit
      pkgs.vimPlugins.plenary-nvim
    ];
    after = [
      "codediff"
      "telescope"
    ];
    setup.args = {
      integrations.codediff = config.config ? codediff;
      integrations.telescope = config.config ? telescope;
    };
  };
}
