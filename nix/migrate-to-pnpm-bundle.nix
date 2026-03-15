{ pkgs }:

let
  # Import pnpm migration packages
  prefer-pnpm = import ./prefer-pnpm.nix { inherit pkgs; };
  force-pnpm-bundle = import ./force-pnpm.nix { inherit pkgs; };
  eject-npm = import ./eject-npm.nix { inherit pkgs; };
  eject-yarn-from-pnpm = import ./eject-yarn-from-pnpm.nix { inherit pkgs; };
  eject-bun-from-pnpm = import ./eject-bun-from-pnpm.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "migrate-to-pnpm";
  paths = [
    prefer-pnpm
    force-pnpm-bundle
    eject-npm
    eject-yarn-from-pnpm
    eject-bun-from-pnpm
  ];
}
