{ pkgs }:

pkgs.writeShellScriptBin "json" ''
  ${builtins.readFile ../wrappers/rtk-tools/json.rtk-wrap.sh}
''