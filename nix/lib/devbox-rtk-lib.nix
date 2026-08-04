{ pkgs }:

# Shared library for creating devbox-rtk wrapper packages
# This function combines devbox-manager.sh and rtk-wrapper.sh utilities with wrapper-specific content
#
# fallbackRtkPackage (optional, default pkgs.rtk): nixpkgs rtk as build-time fallback.
# fallbackDevboxPackage (optional, default pkgs.devbox): nixpkgs devbox as build-time fallback.
# At runtime, the wrapper prefers upstream installs on PATH (excluding its own
# directory); if not found, falls back to the nixpkgs copy baked in here.
# Set either to null to disable that fallback.

{
  name,
  wrapperContent,
  fallbackRtkPackage ? pkgs.rtk,
  fallbackDevboxPackage ? pkgs.devbox,
}:

let
  rtkFallback =
    if fallbackRtkPackage != null
    then "${fallbackRtkPackage}/bin/rtk"
    else "";
  devboxFallback =
    if fallbackDevboxPackage != null
    then "${fallbackDevboxPackage}/bin/devbox"
    else "";
in
pkgs.writeShellScriptBin name ''
  RTK_FALLBACK="${rtkFallback}"
  DEVBOX_FALLBACK="${devboxFallback}"
  ${builtins.readFile ../../wrappers/utils/path-utils.sh}

  ${builtins.readFile ../../wrappers/utils/devbox-manager.sh}

  ${builtins.readFile ../../wrappers/utils/rtk-wrapper.sh}

  ${wrapperContent}
''
