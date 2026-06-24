{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "rubocop";
  nativeCmd = "rubocop";
  rtkSubcommand = "rubocop";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/rubocop.rtk-wrap.sh;
}