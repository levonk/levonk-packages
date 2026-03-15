{ pkgs }:

let
  # Import force packages that replace with pnpm
  force-pnpm = import ./force-pnpm.nix { inherit pkgs; };
  force-yarn-from-pnpm = import ./force-yarn-from-pnpm.nix { inherit pkgs; };
  force-bun-from-pnpm = import ./force-bun-from-pnpm.nix { inherit pkgs; };
  
  # Import eject packages (dependencies)
  eject-npm = import ./eject-npm.nix { inherit pkgs; };
  eject-yarn-from-pnpm = import ./eject-yarn-from-pnpm.nix { inherit pkgs; };
  eject-bun-from-pnpm = import ./eject-bun-from-pnpm.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "force-pnpm";
  paths = [
    force-pnpm
    force-yarn-from-pnpm
    force-bun-from-pnpm
    eject-npm
    eject-yarn-from-pnpm
    eject-bun-from-pnpm
  ];
}
