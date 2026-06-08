{ pkgs }:

pkgs.writeShellScriptBin "swift" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/devbox-reminders/block-devbox.sh}
''
