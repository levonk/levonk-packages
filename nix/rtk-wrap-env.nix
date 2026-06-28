{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "env";
  nativeCmd = "env";
  rtkSubcommand = "env";
  description = "filtered output (sensitive masked)";
  nativePackage = pkgs.coreutils;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/env.rtk-wrap.sh;
}