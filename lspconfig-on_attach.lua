return function(client, bufnr)
  require'lsp-status'.on_attach(client)
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
            hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
            hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
            hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
            augroup lsp_document_highlight
              autocmd! * <buffer>
              autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
              autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
          ]])
  end

  local opts = {buffer = bufnr, silent = true}

  if client.server_capabilities.documentFormattingProvider or
    client.server_capabilities.documentRangeFormattingProvider then
    -- TODO: fix formatting conflicts, see also:
    --   https://neovim.discourse.group/t/how-select-server-vim-lsp-buf-format/3098
    vim.keymap.set('n', '<Leader>F', vim.lsp.buf.format, opts)
  end
end
