{ pkgs, ... }:
{
  configs.ibl = {
    plugins = [ pkgs.vimPlugins.indent-blankline-nvim ];
    setup.args = {
      indent.char = "⎸";
      enabled = false;
    };
    vim = [ "autocmd FileType yaml IBLEnable" ];
  };
}
