{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption types;

  cfg = config.wrapper;

  envType = types.submodule {
    options = {
      values = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of values";
      };
      sep = mkOption {
        type = types.str;
        default = ":";
        description = "Value separator";
      };
    };
  };
in
{
  options.wrapper = {
    name = mkOption {
      type = types.str;
    };
    pkg = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped.override {
        # Disable bundled parsers, we manage it on our own
        # The bundle was not update in the last 12 month. The C
        # parser is not compatible with the latest nvim treesitter
        # plugin. See also
        # https://github.com/NixOS/nixpkgs/pull/227159
        treesitter-parsers = { };
      };
      description = "Neovim package to wrap";
    };
    env = mkOption {
      type = types.attrsOf envType;
      description = "Environment variables";
    };
    drv = mkOption {
      internal = true;
      type = types.package;
    };
  };

  config.wrapper.drv =
    let
      mainProgram = "nvim";
      nvimrc = pkgs.writeText (cfg.name + "-nvimrc.lua") config.out;
      wrapperArgs = builtins.concatStringsSep " "
        (builtins.attrValues
          (builtins.mapAttrs
            (n: v: "--suffix '${n}' '${v.sep}' '${builtins.concatStringsSep v.sep v.values}'")
            cfg.env));
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = cfg.name;
      inherit (cfg.pkg) version;

      dontUnpack = true;

      nativeBuildInputs = [ pkgs.makeWrapper ];

      nativeInstallCheckInputs = [
        # needed by plugin gitsigns
        pkgs.gitMinimal
      ];

      buildPhase = ''
        makeWrapper ${cfg.pkg}/bin/nvim $out/bin/${mainProgram} \
          --add-flags "-u NORC --cmd 'luafile ${nvimrc}'" \
          ${wrapperArgs}
      '';

      doInstallCheck = true;
      installCheckPhase = ''
        HOME=$(pwd) $out/bin/${mainProgram} --headless +"q" 2> err
        if [ -s err ]; then
          cat err
          false
        fi
      '';

      passthru = { inherit nvimrc; };
      meta = { inherit mainProgram; };
    };
}
