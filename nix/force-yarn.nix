{ pkgs }:

let
  yarn = pkgs.yarn;
  # npm → yarn (main wrapper)
  force-yarn-npm = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    echo "✅ Using yarn instead of npm (forced by policy)..."
    exec ${yarn}/bin/yarn "$@"
  '';
  # pnpm → yarn
  force-yarn-from-pnpm = import ./force-yarn-from-pnpm.nix { inherit pkgs; };
  # bun → yarn
  force-yarn-from-bun = import ./force-yarn-from-bun.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "force-yarn";
  paths = [
    force-yarn-npm
    force-yarn-from-pnpm
    force-yarn-from-bun
  ];
}
