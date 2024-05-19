{ config, pkgs, ... }:
{
  configs.neogit = {
    plugins = [ (pkgs.vimPlugins.neogit.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "NeogitOrg";
        repo = "neogit";
        # compatible with neovim 0.9
        # https://github.com/NeogitOrg/neogit/releases/tag/v0.0.1
        rev = "v0.0.1";
        hash = "sha256-xncUButV2/FSOPNolbrZuPPSC1FOtgrlZBwzHHPKCTo=";
      };
    })) ];
    setup.args = {
      integrations.diffview = config.config ? diffview;
      integrations.telescope = config.config ? telescope;
    };
  };
}
