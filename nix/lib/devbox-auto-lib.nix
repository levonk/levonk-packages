{ pkgs }:

# Shared library for creating devbox-auto wrapper packages
# This function combines devbox-manager.sh utility with wrapper-specific content
#
# fallbackPackage (optional, default pkgs.devbox): the nixpkgs derivation
# providing the devbox binary as a build-time fallback. The wrapper bakes the
# absolute store path into DEVBOX_FALLBACK. At runtime, the wrapper first looks
# for devbox on PATH (excluding its own directory, so an upstream install —
# jetify.com installer, manual build, etc. — is preferred). If not found, it
# uses DEVBOX_FALLBACK (the nixpkgs copy). Set to null to disable the fallback
# (wrapper warns + runs the tool directly).

{
  name,
  tool,
  fallbackPackage ? pkgs.devbox,
}:

let
  devboxFallback =
    if fallbackPackage != null
    then "${fallbackPackage}/bin/devbox"
    else "";
in
pkgs.writeShellScriptBin name ''
  DEVBOX_FALLBACK="${devboxFallback}"
  ${builtins.readFile ../../wrappers/utils/path-utils.sh}

  ${builtins.readFile ../../wrappers/utils/devbox-manager.sh}

  devbox_wrap ${tool} "$@"
''
