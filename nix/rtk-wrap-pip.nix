{ pkgs }:

pkgs.writeShellScriptBin "pip" ''
  ${builtins.readFile ../wrappers/rtk-tools/pip.rtk-wrap.sh}
''