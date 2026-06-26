{ pkgs }:

let
  # npm → nub (main wrapper)
  prefer-nub-npm = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/nodejs-tools/npm.prefer-nub.sh}
  '';
  # pnpm → nub
  prefer-nub-from-pnpm = import ./prefer-nub-from-pnpm.nix { inherit pkgs; };
  # yarn → nub
  prefer-nub-from-yarn = import ./prefer-nub-from-yarn.nix { inherit pkgs; };
  # bun → nub
  prefer-nub-from-bun = import ./prefer-nub-from-bun.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "prefer-nub";
  paths = [
    prefer-nub-npm
    prefer-nub-from-pnpm
    prefer-nub-from-yarn
    prefer-nub-from-bun
  ];
}
