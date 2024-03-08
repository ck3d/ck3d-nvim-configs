{ pkgs, ... }:
{
  configs.leap = {
    plugins = [ pkgs.vimPlugins.leap-nvim ];
    lua = [
      "require'leap'.add_default_mappings()"
    ];
  };
}
