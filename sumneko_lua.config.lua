return {
  runtime = {version = "LuaJIT"},
  path = vim.split(package.path, ';'),
  diagnostics = {enable = true, globals = {"vim"}},
  format = {
    -- use lua-format
    enable = false,
  },
  workspace = {
    library = (function()
      local result = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      };
      for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
        local lua_path = path .. "/lua/";
        if vim.fn.isdirectory(lua_path) then result[lua_path] = true end
      end
      return result;
    end)(),
  },
}
