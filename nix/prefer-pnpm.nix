{ pkgs }:

let
  # npm → pnpm (main wrapper)
  prefer-pnpm-npm = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/nodejs-tools/npm.prefer-pnpm.sh}
  '';
  # yarn → pnpm
  prefer-pnpm-from-yarn = import ./prefer-pnpm-from-yarn.nix { inherit pkgs; };
  # bun → pnpm
  prefer-pnpm-from-bun = import ./prefer-pnpm-from-bun.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "prefer-pnpm";
  paths = [
    prefer-pnpm-npm
    prefer-pnpm-from-yarn
    prefer-pnpm-from-bun
  ];
}
