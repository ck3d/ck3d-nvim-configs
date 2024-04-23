{ vimUtils
, fetchFromGitHub
}:
vimUtils.buildVimPlugin {
  pname = "cmp-yank";
  version = "2024-01-13";
  src = fetchFromGitHub {
    owner = "kbwo";
    repo = "cmp-yank";
    rev = "d5439fb7149aefdaa5d644c7c42588dd862c2451";
    hash = "sha256-foIcgyJQaVLBSIg2FbN6GuqVE4tzubuF9C7hwKJRKEk=";
  };
}
