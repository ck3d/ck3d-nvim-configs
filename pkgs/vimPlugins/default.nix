{ vimUtils
, fetchFromGitHub
}:
let
  inherit (vimUtils) buildVimPluginFrom2Nix;
in
{
  nvim-osc52 = buildVimPluginFrom2Nix {
    pname = "nvim-osc52";
    version = "2022-11-10";
    src = fetchFromGitHub {
      owner = "ojroques";
      repo = "nvim-osc52";
      rev = "27b922a88aba9b2533c4a0e0bc5bca65e3405739";
      sha256 = "sha256-ESqihzkYFsKOtAwg9tn5k41BHuSbHGKDnxPBLLtIro8=";
    };
  };
}
