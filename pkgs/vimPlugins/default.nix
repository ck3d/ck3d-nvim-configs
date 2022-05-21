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

  nvim-luapad = buildVimPluginFrom2Nix rec {
    pname = "nvim-luapad";
    version = "0.3-20211229";
    src = fetchFromGitHub {
      owner = "rafcamlet";
      repo = pname;
      rev = "1f31c692f01edb2629f8c489e99e650633915dc2";
      sha256 = "sha256-NLED3aEaDdnIaRKgB8YwV65GABO+lnL1NiLqqvEH+60=c";
    };
    meta.homepage = "https://github.com/rafcamlet/nvim-luapad/";
  };
}
