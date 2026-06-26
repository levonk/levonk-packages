{ pkgs, nub-pkg }:

pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  echo "✅ Using nub instead of pnpm (forced by policy)..."
  exec ${nub-pkg}/bin/nub "$@"
''
