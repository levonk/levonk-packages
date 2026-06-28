{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "grep";
  nativeCmd = "grep";
  rtkSubcommand = "grep";
  description = "compact grep output";
  nativePackage = pkgs.gnugrep;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/grep.rtk-wrap.sh;
}