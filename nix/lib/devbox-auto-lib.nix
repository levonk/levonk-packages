{ pkgs }:

# Shared library for creating devbox-auto wrapper packages
# This function combines devbox-manager.sh utility with wrapper-specific content

{
  name,
  tool,
}:

pkgs.writeShellScriptBin name ''
  ${builtins.readFile ../../wrappers/utils/devbox-manager.sh}
  
  devbox_wrap ${tool} "$@"
''
