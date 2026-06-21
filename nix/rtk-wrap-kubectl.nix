{ pkgs }:

pkgs.writeShellScriptBin "kubectl" ''
  ${builtins.readFile ../wrappers/rtk-tools/kubectl.rtk-wrap.sh}
''