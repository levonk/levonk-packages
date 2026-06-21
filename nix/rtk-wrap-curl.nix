{ pkgs }:

pkgs.writeShellScriptBin "curl" ''
  ${builtins.readFile ../wrappers/rtk-tools/curl.rtk-wrap.sh}
''