{ pkgs, nix2nvimrc, ... }:
{
  configs.project_nvim = {
    after = [ "telescope" ];
    plugins = [ pkgs.vimPlugins.project-nvim ];
    lua = [ "require'telescope'.load_extension('projects')" ];
    setup.args = {
      patters = [ ".envrc" ];
    };
    keymaps = map (nix2nvimrc.toKeymap { silent = true; }) [
      [
        "n"
        "<Leader>fp"
        "<Cmd>Telescope projects<CR>"
        { }
      ]
    ];
  };
}
