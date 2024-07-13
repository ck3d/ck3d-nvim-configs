{ buildNpmPackage }:
buildNpmPackage {
  pname = "nvim-tsserver-vue-env";
  version = "0.0.1";
  src = ./.;

  dontNpmBuild = true;

  postInstall = ''
    mv $out/lib/node_modules/*/node_modules $out
    rm -rf $out/lib
    ln -s node_modules/.bin $out/bin
  '';

  npmDepsHash = "sha256-KBK5+qH18TaQfxMMDrT3j4tTfLBcE8YKM9XNpMA/bSc=";
}
