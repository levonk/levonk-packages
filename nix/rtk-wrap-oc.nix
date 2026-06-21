{ pkgs }:

pkgs.writeShellScriptBin "oc" ''
  ${builtins.readFile ../wrappers/rtk-tools/oc.rtk-wrap.sh}
''