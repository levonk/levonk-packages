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
# fallbackPackage (optional, default pkgs.rtk): the nixpkgs derivation providing
# the rtk binary as a build-time fallback. The wrapper bakes the absolute store
# path into RTK_FALLBACK. At runtime, the wrapper first looks for rtk on PATH
# (excluding its own directory, so an upstream install — github:rtk-ai/rtk,
# manual build, etc. — is preferred). If not found, it uses RTK_FALLBACK (the
# nixpkgs copy). Set to null to disable the fallback (wrapper warns + uses native).
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
  fallbackPackage ? pkgs.rtk,
  rtkOnly ? false,
}:

let
  nativeBin =
    if nativePackage != null
    then "${nativePackage}/bin/${nativeCmd}"
    else nativeCmd;
  rtkFallback =
    if fallbackPackage != null
    then "${fallbackPackage}/bin/rtk"
    else "";
in
pkgs.writeShellScriptBin name ''
  RTK_FALLBACK="${rtkFallback}"
  ${builtins.readFile ../../wrappers/utils/rtk-wrapper.sh}

  ${wrapperContent}

  RTK_ONLY=${if rtkOnly then "1" else "0"} rtk_wrap ${nativeBin} ${rtkSubcommand} "${description}" "$@"
''