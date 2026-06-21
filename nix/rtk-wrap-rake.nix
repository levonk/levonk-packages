{ pkgs }:

pkgs.writeShellScriptBin "rake" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/rake.rtk-wrap.sh}
''