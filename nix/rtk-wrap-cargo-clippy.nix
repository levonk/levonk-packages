{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "cargo-clippy";
  nativeCmd = "cargo-clippy";
  rtkSubcommand = "cargo-clippy";
  description = "compact clippy output";
  nativePackage = pkgs.cargo;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/cargo-clippy.rtk-wrap.sh;
}