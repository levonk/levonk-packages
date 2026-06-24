{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "gradlew";
  nativeCmd = "gradlew";
  rtkSubcommand = "gradlew";
  description = "compact Android build output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/gradlew.rtk-wrap.sh;
}