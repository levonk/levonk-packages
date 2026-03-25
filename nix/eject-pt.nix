{ pkgs }:

pkgs.writeShellScriptBin "pt" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/search-tools/pt.eject-pt.sh}
''
