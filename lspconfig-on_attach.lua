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

  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', '<Leader>F',
                   function() vim.lsp.buf.format({async = true}) end, opts)
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set('v', '<Leader>F',
                   function() vim.lsp.buf.format({async = true}) end, opts)
  end
end
