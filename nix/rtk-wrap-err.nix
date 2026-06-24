{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "err";
  nativeCmd = "err";
  rtkSubcommand = "err";
  description = "show only errors/warnings";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/err.rtk-wrap.sh;
}