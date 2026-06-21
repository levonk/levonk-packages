{ pkgs }:

pkgs.writeShellScriptBin "kubectl" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/kubectl.rtk-wrap.sh}
''