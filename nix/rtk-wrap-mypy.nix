{ pkgs }:

pkgs.writeShellScriptBin "mypy" ''
  ${builtins.readFile ../wrappers/rtk-tools/mypy.rtk-wrap.sh}
''