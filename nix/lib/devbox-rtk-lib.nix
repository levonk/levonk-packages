{ pkgs }:

# Shared library for creating devbox-rtk wrapper packages
# This function combines devbox-manager.sh and rtk-wrapper.sh utilities with wrapper-specific content

{
  name,
  wrapperContent,
}:

pkgs.writeShellScriptBin name ''
  ${builtins.readFile ../../wrappers/utils/devbox-manager.sh}
  
  ${builtins.readFile ../../wrappers/utils/rtk-wrapper.sh}
  
  ${wrapperContent}
''
