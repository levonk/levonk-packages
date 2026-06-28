{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "oc";
  nativeCmd = "oc";
  rtkSubcommand = "oc";
  description = "compact OpenShift output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/oc.rtk-wrap.sh;
}