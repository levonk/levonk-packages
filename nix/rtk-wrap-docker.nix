{ pkgs }:

pkgs.writeShellScriptBin "docker" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/docker.rtk-wrap.sh}
''