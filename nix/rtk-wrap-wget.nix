{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "wget";
  nativeCmd = "wget";
  rtkSubcommand = "wget";
  description = "compact output (strips progress bars)";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/wget.rtk-wrap.sh;
}