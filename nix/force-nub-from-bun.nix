{ pkgs, nub-pkg }:

pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "✅ Using nub instead of bun (forced by policy)..."
  exec ${nub-pkg}/bin/nub "$@"
''
