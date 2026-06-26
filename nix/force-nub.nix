{ pkgs, nub-pkg }:

let
  # npm → nub (main wrapper)
  force-nub-npm = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    echo "✅ Using nub instead of npm (forced by policy)..."
    exec ${nub-pkg}/bin/nub "$@"
  '';
  # pnpm → nub
  force-nub-from-pnpm = import ./force-nub-from-pnpm.nix { inherit pkgs nub-pkg; };
  # yarn → nub
  force-nub-from-yarn = import ./force-nub-from-yarn.nix { inherit pkgs nub-pkg; };
  # bun → nub
  force-nub-from-bun = import ./force-nub-from-bun.nix { inherit pkgs nub-pkg; };
in
pkgs.symlinkJoin {
  name = "force-nub";
  paths = [
    force-nub-npm
    force-nub-from-pnpm
    force-nub-from-yarn
    force-nub-from-bun
  ];
}
