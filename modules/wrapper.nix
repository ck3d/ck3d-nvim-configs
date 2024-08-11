{
  config,
  lib,
  pkgs,
  ...
}:
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
  options = {
    wrapper = {
      name = mkOption { type = types.str; };
      pkg = mkOption {
        type = types.package;
        default = pkgs.neovim-unwrapped;
        description = "Neovim package to wrap";
      };
      drv = mkOption {
        internal = true;
        type = types.package;
      };
    };

    configs = mkOption {
      type = types.attrsOf (
        types.submodule {
          options.env = mkOption {
            type = types.attrsOf envType;
            description = "Environment variables";
            default = { };
          };
        }
      );
    };
  };

  config.wrapper.drv =
    let
      mainProgram = "nvim";
      nvimrc = pkgs.writeText (cfg.name + "-nvimrc.lua") config.out;
      wrapperArgs =
        let
          envs = builtins.catAttrs "env" (builtins.attrValues config.configs);
        in
        [
          "--add-flags"
          "-u NORC --cmd 'luafile ${nvimrc}'"
        ]
        ++ (builtins.concatMap (
          env:
          (builtins.concatMap (
            n:
            let
              v = env.${n};
            in
            [
              "--suffix"
              n
              v.sep
              (builtins.concatStringsSep v.sep v.values)
            ]
          ) (builtins.attrNames env))
        ) envs);
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = cfg.name;
      inherit (cfg.pkg) version;

      dontUnpack = true;

      nativeBuildInputs = [ pkgs.makeWrapper ];

      buildPhase = ''
        makeWrapper ${cfg.pkg}/bin/nvim "$out/bin/${mainProgram}" \
          ${lib.escapeShellArgs wrapperArgs}
      '';

      doInstallCheck = true;
      installCheckPhase = ''
        HOME=$(pwd) $out/bin/${mainProgram} --headless +"q" 2> err
        if [ -s err ]; then
          cat err
          false
        fi
      '';

      passthru = {
        inherit nvimrc;
        tests.languages = pkgs.runCommandNoCC "test-languages" { } (
          lib.concatMapStrings (language: ''
            echo test ${language}
            HOME=$(pwd) ${config.wrapper.drv}/bin/${mainProgram} --headless +"lua vim.wait(20, function() end)" +"q" test.${language} 2> err
            if [ -s err ]; then
              cat err
              LSP_LOG=.local/state/nvim/lsp.log
              if [ -f "$LSP_LOG" ]; then
                cat "$LSP_LOG"
              fi
              false
            fi
          '') (config.languages or [ ])
          + ''
            mv .local/state/nvim $out
          ''
        );
      };
      meta = {
        inherit mainProgram;
      };
    };
}
