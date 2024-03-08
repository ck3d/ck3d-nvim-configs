{ pkgs, ... }:
{
  configs.lsp_extensions = {
    after = [ "lspconfig" ];
    plugins = [ pkgs.vimPlugins.lsp_extensions-nvim ];
    vim = [
      "autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }"
    ];
  };
}
