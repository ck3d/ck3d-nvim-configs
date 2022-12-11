{ fetchurl
, runCommandLocal
, makeWrapper
, jre_headless
}:
let
  pname = "lemminx";
  version = "0.22.0";
  jar = fetchurl {
    url = "https://repo.eclipse.org/content/repositories/lemminx-releases/org/eclipse/lemminx/org.eclipse.lemminx/${version}/org.eclipse.lemminx-${version}-uber.jar";
    sha256 = "sha256-brbjcRX1vW1M2G5yEktpjY67vxkso3w7OsSUpfQLDE4=";
  };
in
runCommandLocal "${pname}-${version}"
{
  nativeBuildInputs = [ makeWrapper ];
} ''
  makeWrapper ${jre_headless}/bin/java $out/bin/${pname} \
    --add-flags "-jar ${jar}"
''
