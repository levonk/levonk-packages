{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "aws";
  nativeCmd = "aws";
  rtkSubcommand = "aws";
  description = "compact output (force JSON, compress)";
  nativePackage = pkgs.awscli;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/aws.rtk-wrap.sh;
}