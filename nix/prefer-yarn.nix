{ pkgs }:

let
  yarn = pkgs.yarn;
  # npm → yarn (main wrapper)
  prefer-yarn-npm = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/nodejs-tools/npm.prefer-yarn.sh}
  '';
  # pnpm → yarn
  prefer-yarn-from-pnpm = import ./prefer-yarn-from-pnpm.nix { inherit pkgs; };
  # bun → yarn
  prefer-yarn-from-bun = import ./prefer-yarn-from-bun.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "prefer-yarn";
  paths = [
    prefer-yarn-npm
    prefer-yarn-from-pnpm
    prefer-yarn-from-bun
  ];
}
