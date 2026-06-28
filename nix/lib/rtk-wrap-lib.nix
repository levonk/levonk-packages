{ pkgs }:

# Shared library for creating RTK wrapper packages
# This function combines the rtk-wrapper.sh utility with wrapper-specific content
#
# nativePackage (optional): the nixpkgs derivation providing the real native binary.
# When set, the wrapper execs ${nativePackage}/bin/${nativeCmd} directly (absolute
# store path), preventing infinite recursion when the wrapper itself is in PATH.
# When null, the wrapper falls back to PATH-exclusion (removing its own directory
# from PATH before resolving the native command).
#
# rtkOnly (optional, default false): when true, this is an RTK-specific command
# with no native equivalent (e.g. err, json, deps, lint, format). The wrapper
# IS the command — it always runs through RTK and fails with a clear error if
# RTK is not installed. No native fallback is attempted.

{
  name,
  nativeCmd,
  rtkSubcommand ? nativeCmd,
  description ? "token-optimized output",
  wrapperContent,
  nativePackage ? null,
  rtkOnly ? false,
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

  RTK_ONLY=${if rtkOnly then "1" else "0"} rtk_wrap ${nativeBin} ${rtkSubcommand} "${description}" "$@"
''