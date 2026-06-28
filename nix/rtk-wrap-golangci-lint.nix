{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "golangci-lint";
  nativeCmd = "golangci-lint";
  rtkSubcommand = "golangci-lint";
  description = "compact run support";
  nativePackage = pkgs.golangci-lint;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/golangci-lint.rtk-wrap.sh;
}