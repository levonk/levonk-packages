{ pkgs }:

# Shared library for creating RTK wrapper packages
# This function combines the rtk-wrapper.sh utility with wrapper-specific content

{
  name,
  nativeCmd,
  rtkSubcommand ? nativeCmd,
  description ? "token-optimized output",
  wrapperContent,
}:

pkgs.writeShellScriptBin name ''
  ${builtins.readFile ../../wrappers/utils/rtk-wrapper.sh}
  
  ${wrapperContent}
  
  rtk_wrap ${nativeCmd} ${rtkSubcommand} "${description}"
''