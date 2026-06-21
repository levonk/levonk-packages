{ pkgs }:

pkgs.writeShellScriptBin "ruff" ''
  ${builtins.readFile ../wrappers/rtk-tools/ruff.rtk-wrap.sh}
''