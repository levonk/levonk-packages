{ pkgs }:

# Shared library for creating RTK wrapper packages
# This function combines the rtk-wrapper.sh utility with wrapper-specific content
#
# nativePackage (optional): the nixpkgs derivation providing the real native binary.
# When set, the wrapper execs ${nativePackage}/bin/${nativeCmd} directly (absolute
# store path), preventing infinite recursion when the wrapper itself is in PATH.
# When null, the wrapper falls back to PATH-exclusion (removing its own directory
# from PATH before resolving the native command).

{
  name,
  nativeCmd,
  rtkSubcommand ? nativeCmd,
  description ? "token-optimized output",
  wrapperContent,
  nativePackage ? null,
}:

let
  nativeBin =
    if nativePackage != null
    then "${nativePackage}/bin/${nativeCmd}"
    else nativeCmd;
in
pkgs.writeShellScriptBin name ''
  ${builtins.readFile ../../wrappers/utils/rtk-wrapper.sh}

  ${wrapperContent}

  rtk_wrap ${nativeBin} ${rtkSubcommand} "${description}" "$@"
''