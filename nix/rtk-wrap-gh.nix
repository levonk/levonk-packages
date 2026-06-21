{ pkgs }:

pkgs.writeShellScriptBin "gh" ''
  ${builtins.readFile ../wrappers/rtk-tools/gh.rtk-wrap.sh}
''