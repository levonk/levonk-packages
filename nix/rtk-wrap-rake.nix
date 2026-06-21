{ pkgs }:

pkgs.writeShellScriptBin "rake" ''
  ${builtins.readFile ../wrappers/rtk-tools/rake.rtk-wrap.sh}
''