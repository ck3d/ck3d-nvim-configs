{ pkgs, ... }:
{
  configs.Comment = {
    plugins = [ pkgs.vimPlugins.comment-nvim ];
    setup = { };
  };
}
