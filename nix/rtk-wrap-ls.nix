{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "ls";
  nativeCmd = "ls";
  rtkSubcommand = "ls";
  description = "token-optimized output";
  nativePackage = pkgs.coreutils;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/ls.rtk-wrap.sh;
}