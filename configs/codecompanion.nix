{ pkgs, ... }:
{
  configs.codecompanion = {
    plugins = [ pkgs.vimPlugins.codecompanion-nvim ];
    setup.args = {
      interactions = {
        chat = {
          adapter = "gemini_cli";
        };
      };
    };
  };
}
