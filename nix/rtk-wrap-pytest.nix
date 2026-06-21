{ pkgs }:

pkgs.writeShellScriptBin "pytest" ''
  ${builtins.readFile ../wrappers/rtk-tools/pytest.rtk-wrap.sh}
''