{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "curl";
  nativeCmd = "curl";
  rtkSubcommand = "curl";
  description = "auto-JSON detection and schema output";
  nativePackage = pkgs.curl;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/curl.rtk-wrap.sh;
}