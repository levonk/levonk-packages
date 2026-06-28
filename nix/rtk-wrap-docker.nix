{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "docker";
  nativeCmd = "docker";
  rtkSubcommand = "docker";
  description = "compact output";
  nativePackage = pkgs.docker;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/docker.rtk-wrap.sh;
}