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
    vim.keymap.set('n', '<Leader>F', function()
      local clients = vim.lsp.get_active_clients({bufnr = bufnr})

      local filter = function(c)
        return c.name ~= 'sumneko_lua' -- use lua-format
      end

      clients = vim.tbl_filter(function(c)
        return c.supports_method('textDocument/formatting')
      end, clients)
      clients = vim.tbl_filter(filter, clients)

      if #clients > 1 then
        table.sort(clients, function(a, b) return a.name < b.name end)
        clients = vim.ui.select(clients, {
          prompt = 'Select a language server:',
          format_item = function(c) return c.name end,
        }, function(choise)
          vim.lsp.buf.format({bufnr = bufnr, id = choise.id})
        end)
      else
        vim.lsp.buf.format({bufnr = bufnr, filter = filter})
      end
    end, opts)
  end
end
