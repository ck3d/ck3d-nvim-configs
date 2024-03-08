{ pkgs, ... }:
{
  configs.registers = {
    plugins = [ pkgs.vimPlugins.registers-nvim ];
    setup = { };
  };
}
