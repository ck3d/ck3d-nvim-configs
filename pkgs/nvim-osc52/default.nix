{ vimUtils
, fetchFromGitHub
}:
let
  inherit (vimUtils) buildVimPluginFrom2Nix;
in
buildVimPluginFrom2Nix {
  pname = "nvim-osc52";
  version = "2023-02-16";
  src = fetchFromGitHub {
    owner = "ojroques";
    repo = "nvim-osc52";
    rev = "358a2b4804c5f35b9ab6975cf68611afcbbc9b0d";
    sha256 = "sha256-R8CAr0cJB8RwV7iL2YB5Ci/WtKUSTdCh1TBtqKMVKe8=";
  };
}
