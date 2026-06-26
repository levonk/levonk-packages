{ pkgs, nub-pkg }:

pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "✅ Using nub instead of npm (forced by policy)..."
  exec ${nub-pkg}/bin/nub "$@"
''
