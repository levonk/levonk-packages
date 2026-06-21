{ pkgs }:

pkgs.writeShellScriptBin "pnpm" ''
  ${builtins.readFile ../wrappers/rtk-tools/pnpm.rtk-wrap.sh}
''