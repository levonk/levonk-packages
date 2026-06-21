{ pkgs }:

pkgs.writeShellScriptBin "git" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/git.rtk-wrap.sh}
''