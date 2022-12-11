{ vimUtils
, fetchFromGitHub
}:
let
  inherit (vimUtils) buildVimPluginFrom2Nix;
in
{
  nvim-osc52 = buildVimPluginFrom2Nix {
    pname = "nvim-osc52";
    version = "2022-11-22";
    src = fetchFromGitHub {
      owner = "ojroques";
      repo = "nvim-osc52";
      rev = "5e7efbc047be9eca1307899137a89cd2b6b8125a";
      sha256 = "sha256-tr0MeOdXf9ndJpdoBy8vyahuPdwXk94JyEQO3ppzfkU=";
    };
  };
}
