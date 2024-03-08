{ pkgs, config, nix2nvimrc, ... }:
let
  inherit (nix2nvimrc) luaExpr;
in
{
  configs.lualine = {
    after = [ "lsp-status" ];
    plugins = [ pkgs.vimPlugins.lualine-nvim ];
    setup.args = {
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          (luaExpr "{'diagnostics', sources={'nvim_diagnostic'}}")
        ];
        lualine_c = [ (luaExpr "{'filename', path = 1}") ];
        lualine_x = [
          "require'lsp-status'.status()"
          "diff"
          "filetype"
          "b:toggle_number"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      options = { theme = "gruvbox_${config.opt.background}"; };
    };
  };
}
