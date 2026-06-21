{ pkgs }:

pkgs.writeShellScriptBin "docker" ''
  ${builtins.readFile ../wrappers/rtk-tools/docker.rtk-wrap.sh}
''