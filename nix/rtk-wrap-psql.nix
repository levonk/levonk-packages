{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "psql";
  nativeCmd = "psql";
  rtkSubcommand = "psql";
  description = "compact output (strip borders, compress tables)";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/psql.rtk-wrap.sh;
}