{ pkgs }:

pkgs.writeShellScriptBin "glab" ''
  ${builtins.readFile ../wrappers/rtk-tools/glab.rtk-wrap.sh}
''