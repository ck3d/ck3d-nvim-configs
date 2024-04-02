{ vimUtils
, fetchFromGitHub
}:
vimUtils.buildVimPlugin {
  pname = "outline.nvim";
  version = "2024-03-16";
  src = fetchFromGitHub {
    owner = "hedyhli";
    repo = "outline.nvim";
    rev = "bdfd2da90e9a7686d00e55afa9f772c4b6809413";
    hash = "sha256-Il27Z/vQVJ3WSrFnTOUwBeAFCjopXwDhdsi7A5v1gzU=";
  };
}
