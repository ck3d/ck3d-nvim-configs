{ pkgs, ... }:
{
  configs = [{
    name = "nvim-web-devicons";
    plugins = [ pkgs.vimPlugins.nvim-web-devicons ];
    setup = { default = true; };
  }];
}
