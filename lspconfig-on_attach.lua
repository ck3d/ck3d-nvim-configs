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

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = {noremap = true, silent = true}

  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap('n', '<Leader>F', '<cmd>lua vim.lsp.buf.formatting()<CR>',
                   opts)
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    buf_set_keymap('v', '<Leader>F',
                   '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end
end
