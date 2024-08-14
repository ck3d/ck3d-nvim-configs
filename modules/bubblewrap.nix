{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.bubblewrap;
in
{
  options = {
    bubblewrap = {
      pkg = mkOption {
        type = types.package;
        default = config.wrapper.drv;
        description = "Neovim package to wrap";
      };
      drv = mkOption {
        internal = true;
        type = types.package;
      };
    };
  };

  config.bubblewrap.drv =
    let
      inherit (cfg.pkg.meta) mainProgram;
      wrapperArgs = [
        "--add-flags"
        "--dev-bind / / --unshare-net ${lib.getExe cfg.pkg}"
      ];
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = cfg.pkg.pname + "-bwrap";
      inherit (cfg.pkg) version;

      dontUnpack = true;

      nativeBuildInputs = [
        pkgs.makeWrapper
        pkgs.versionCheckHook
      ];

      versionCheckProgram = "${builtins.placeholder "out"}/bin/${mainProgram}";
      doInstallCheck = true;

      buildPhase = ''
        makeWrapper ${lib.getExe pkgs.bubblewrap} "$out/bin/${mainProgram}" \
          ${lib.escapeShellArgs wrapperArgs}
      '';

      meta = {
        inherit mainProgram;
      };
    };
}
