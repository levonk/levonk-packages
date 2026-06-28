{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "kubectl";
  nativeCmd = "kubectl";
  rtkSubcommand = "kubectl";
  description = "compact output";
  nativePackage = pkgs.kubectl;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/kubectl.rtk-wrap.sh;
}