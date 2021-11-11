{ vimUtils
, fetchFromGitHub
}:
let
  inherit (vimUtils) buildVimPluginFrom2Nix;
in
{
  cmp-nvim-tags = buildVimPluginFrom2Nix rec {
    pname = "cmp-nvim-tags";
    version = "20210916";
    src = fetchFromGitHub {
      owner = "quangnguyen30192";
      repo = pname;
      rev = "51cb13c2a649d81cd88cbd00654b0998d1ee7fa6";
      sha256 = "sha256-Vu636QTwO/Bm7WDyMnJx7AM2+Co2Fp3i1cB48C7du7w=";
    };
    meta.homepage = "https://github.com/quangnguyen30192/cmp-nvim-tags";
  };

  nvim-luapad = buildVimPluginFrom2Nix rec {
    pname = "nvim-luapad";
    version = "0.2";
    patches = [
      ./0001-fix-temp-file.patch
    ];
    src = fetchFromGitHub {
      owner = "rafcamlet";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-NV6cUCBDhxG+0yFDRi12I0IJ54jOMWCYoi0HvmKSBWM=";
    };
    meta.homepage = "https://github.com/rafcamlet/nvim-luapad/";
  };
}
