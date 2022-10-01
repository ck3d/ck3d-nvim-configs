{ vimUtils
, fetchFromGitHub
}:
let
  inherit (vimUtils) buildVimPluginFrom2Nix;
in
{
  cmp-nvim-tags = buildVimPluginFrom2Nix rec {
    pname = "cmp-nvim-tags";
    version = "20220331";
    src = fetchFromGitHub {
      owner = "quangnguyen30192";
      repo = pname;
      rev = "98b15fee0cd64760345be3a30f1a592b5a9abb20";
      sha256 = "sha256-RwRL18inq2X70Cq78rXa50xUX419RoAPoPmrq7r6z6U=";
    };
    meta.homepage = "https://github.com/quangnguyen30192/cmp-nvim-tags";
  };
}
