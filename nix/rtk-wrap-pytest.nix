{ pkgs }:

pkgs.writeShellScriptBin "pytest" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/pytest.rtk-wrap.sh}
''