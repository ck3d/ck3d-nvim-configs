{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.sandbox-exec;
in
{
  options = {
    sandbox-exec = {
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

  config.sandbox-exec.drv =
    let
      inherit (cfg.pkg.meta) mainProgram;

      # macOS Seatbelt profile: read-only access to the whole filesystem,
      # with network denied. Similar to bwrap's --dev-bind / / --unshare-net.
      sandboxProfile = pkgs.writeText "nvim-sandbox.sb" ''
        (version 1)

        ; Deny everything by default
        (deny default)

        ; Allow read-only access to the entire filesystem
        (allow file-read*)

        ; Allow writing everywhere (needed for nvim temp files,
        ; shada, swap, undo, and user project files)
        (allow file-write*)

        ; Deny network access (equivalent to --unshare-net)
        (deny network*)

        ; Allow signals and process management
        (allow signal (target same-sandbox))
        (allow process-fork)
        (allow process-exec)

        ; Allow sysctl reads (needed by many programs)
        (allow sysctl-read)

        ; Allow mach lookups (needed by many macOS programs)
        (allow mach-lookup)

        ; Allow ipc-posix-shm (needed by some tools)
        (allow ipc-posix-shm)

        ; Allow terminal and tty ioctls
        (allow pseudo-tty)
        (allow file-ioctl)
        (allow file-ioctl (literal "/dev/tty"))
        (allow file-ioctl (literal "/dev/ptmx"))
        (allow file-ioctl (regex #"^/dev/ttys"))

        ; Allow shared memory
        (allow system-socket)
      '';
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = cfg.pkg.pname + "-sandbox";
      inherit (cfg.pkg) version passthru;

      dontUnpack = true;

      nativeBuildInputs = [ pkgs.makeWrapper ];

      buildPhase = ''
        mkdir -p "$out/bin"
        cat > "$out/bin/${mainProgram}" <<'SCRIPT'
        #!${pkgs.bash}/bin/bash
        exec /usr/bin/sandbox-exec -f ${sandboxProfile} ${lib.getExe cfg.pkg} "$@"
        SCRIPT
        chmod +x "$out/bin/${mainProgram}"
      '';

      meta = {
        inherit mainProgram;
        platforms = [
          "aarch64-darwin"
          "x86_64-darwin"
        ];
      };
    };
}
