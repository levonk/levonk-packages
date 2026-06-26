{ pkgs, nub-pkg }:

pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "✅ Using nub instead of yarn (forced by policy)..."
  exec ${nub-pkg}/bin/nub "$@"
''
