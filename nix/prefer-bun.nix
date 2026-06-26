{ pkgs }:

let
  bun = pkgs.bun;
  # npm → bun (main wrapper)
  prefer-bun-npm = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/nodejs-tools/npm.prefer-bun.sh}
  '';
  # pnpm → bun
  prefer-bun-from-pnpm = import ./prefer-bun-from-pnpm.nix { inherit pkgs; };
  # yarn → bun
  prefer-bun-from-yarn = import ./prefer-bun-from-yarn.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "prefer-bun";
  paths = [
    prefer-bun-npm
    prefer-bun-from-pnpm
    prefer-bun-from-yarn
  ];
}
