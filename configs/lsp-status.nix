{ pkgs, ... }:
{
  configs.lsp-status = {
    plugins = [ pkgs.vimPlugins.lsp-status-nvim ];
    lua = [ "require'lsp-status'.register_progress()" ];
  };
}
