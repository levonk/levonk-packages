{ pkgs }:

pkgs.writeShellScriptBin "wget" ''
  ${builtins.readFile ../wrappers/rtk-tools/wget.rtk-wrap.sh}
''