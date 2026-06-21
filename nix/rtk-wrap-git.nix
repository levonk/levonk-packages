{ pkgs }:

pkgs.writeShellScriptBin "git" ''
  ${builtins.readFile ../wrappers/rtk-tools/git.rtk-wrap.sh}
''