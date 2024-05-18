{ pkgs, ... }:
{
  configs.gitsigns = {
    plugins = [ pkgs.vimPlugins.gitsigns-nvim ];
    setup.args = {
      current_line_blame = true;
      current_line_blame_opts = {
        ignore_whitespace = true;
      };
      on_attach = ./gitsigns-on_attach.lua;
    };
    env.PATH.values = [ "${pkgs.gitMinimal}/bin" ];
  };
}
