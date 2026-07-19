{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "playwright";
  nativeCmd = "playwright";
  rtkSubcommand = "playwright";
  description = "compact E2E test output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/playwright.rtk-wrap.sh;
}
