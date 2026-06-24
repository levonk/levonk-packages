{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "vitest";
  nativeCmd = "vitest";
  rtkSubcommand = "vitest";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/vitest.rtk-wrap.sh;
}