{ pkgs }:

let
  # pnpm → npm
  prefer-npm-from-pnpm = import ./prefer-npm-from-pnpm.nix { inherit pkgs; };
  # yarn → npm
  prefer-npm-from-yarn = import ./prefer-npm-from-yarn.nix { inherit pkgs; };
  # bun → npm
  prefer-npm-from-bun = import ./prefer-npm-from-bun.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "prefer-npm";
  paths = [
    prefer-npm-from-pnpm
    prefer-npm-from-yarn
    prefer-npm-from-bun
  ];
}
