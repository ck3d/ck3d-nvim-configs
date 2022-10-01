{ vimUtils
, fetchFromGitHub
}:
let
  inherit (vimUtils) buildVimPluginFrom2Nix;
in
{
  # https://github.com/TimUntersberger/neogit/pull/355
  neogit = buildVimPluginFrom2Nix {
    pname = "neogit";
    version = "2022-09-30";
    src = fetchFromGitHub {
      owner = "TimUntersberger";
      repo = "neogit";
      rev = "2a71a5595b49da8a21a20ab8644df9ad0b856ebb";
      sha256 = "sha256-7CCAkrTLOYuSwNnMaPsnkp/PZbaCO/HX1ePQsmWDv9A=";
    };
    meta.homepage = "https://github.com/TimUntersberger/neogit/";
  };
}
