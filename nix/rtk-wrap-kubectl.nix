{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "kubectl";
  nativeCmd = "kubectl";
  rtkSubcommand = "kubectl";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/kubectl.rtk-wrap.sh;
}