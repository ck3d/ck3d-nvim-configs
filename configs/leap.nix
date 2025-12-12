{ pkgs, ... }:
{
  configs.leap = {
    plugins = [ pkgs.vimPlugins.leap-nvim ];
    lua = [
      ''
        vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
        vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
      ''
    ];
  };
}
