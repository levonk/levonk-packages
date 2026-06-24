{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "prisma";
  nativeCmd = "prisma";
  rtkSubcommand = "prisma";
  description = "compact output (no ASCII art)";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/prisma.rtk-wrap.sh;
}