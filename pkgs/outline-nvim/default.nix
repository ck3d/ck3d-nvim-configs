{ vimUtils
, fetchFromGitHub
}:
vimUtils.buildVimPlugin {
  pname = "outline.nvim";
  version = "2024-01-24";
  src = fetchFromGitHub {
    owner = "hedyhli";
    repo = "outline.nvim";
    rev = "a8d40aecb799196303ff3521c0e31c87bba57198";
    hash = "sha256-HaxfnvgFy7fpa2CS7/dQhf6dK9+Js7wP5qGdIeXLGPY=";
  };
}
