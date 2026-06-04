{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.sandbox;
in
{
  options = {
    sandbox = {
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

  config.sandbox.drv =
    let
      inherit (cfg.pkg.meta) mainProgram;
      isDarwin = pkgs.stdenvNoCC.hostPlatform.isDarwin;

      sandboxProfile = pkgs.writeText "nvim-sandbox.sb" ''
        (version 1)
        (deny default)
        (allow file-read*)
        ; Needed for nvim temp files, shada, swap, undo, and user project files
        (allow file-write*)
        (deny network*)

        (allow signal (target same-sandbox))
        (allow process-fork)
        (allow process-exec)

        (allow sysctl-read)
        (allow mach-lookup)
        (allow ipc-posix-shm)

        (allow pseudo-tty)
        (allow file-ioctl)
        (allow file-ioctl (literal "/dev/tty"))
        (allow file-ioctl (literal "/dev/ptmx"))
        (allow file-ioctl (regex #"^/dev/ttys"))

        (allow system-socket)
      '';

    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = cfg.pkg.pname + "-sandbox";
      inherit (cfg.pkg) version passthru;

      dontUnpack = true;

      nativeBuildInputs = lib.optionals (!isDarwin) [
        pkgs.makeWrapper
        pkgs.versionCheckHook
      ];

      versionCheckProgram = "${placeholder "out"}/bin/${mainProgram}";

      buildPhase =
        if isDarwin then
          ''
            mkdir -p "$out/bin"
            cat > "$out/bin/${mainProgram}" <<'SCRIPT'
            #!${lib.getExe pkgs.bash}
            exec /usr/bin/sandbox-exec -f ${sandboxProfile} ${lib.getExe cfg.pkg} "$@"
            SCRIPT
            chmod +x "$out/bin/${mainProgram}"
          ''
        else
          ''
            makeWrapper ${lib.getExe pkgs.bubblewrap} "$out/bin/${mainProgram}" \
              --add-flags "--dev-bind / / --unshare-net ${lib.getExe cfg.pkg}"
          '';

      meta = {
        inherit mainProgram;
        platforms = if isDarwin then lib.platforms.darwin else pkgs.bubblewrap.meta.platforms;
      };
    };
}
