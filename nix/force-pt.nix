{ pkgs }:

pkgs.writeShellScriptBin "pt" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/pt.force-pt.sh}
''
