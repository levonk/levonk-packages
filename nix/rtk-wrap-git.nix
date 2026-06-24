{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "git";
  nativeCmd = "git";
  rtkSubcommand = "git";
  description = "token-optimized output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/git.rtk-wrap.sh;
}