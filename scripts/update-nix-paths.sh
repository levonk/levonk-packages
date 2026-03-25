#!/bin/bash
set -euo pipefail

# Script to update all Nix derivations to use new wrapper paths

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔧 Updating Nix derivations to use new wrapper paths..."

# Find all .nix files and update paths
find "$PROJECT_ROOT/nix" -name "*.nix" | while read -r nix_file; do
    echo "Processing: $nix_file"
    
    # Create a temporary file for the updated content
    temp_file=$(mktemp)
    
    # Update paths in the file using sed
    sed -i.bak \
        -e 's|../wrappers/npm\.|../wrappers/nodejs-tools/npm.|g' \
        -e 's|../wrappers/pnpm\.|../wrappers/nodejs-tools/pnpm.|g' \
        -e 's|../wrappers/yarn\.|../wrappers/nodejs-tools/yarn.|g' \
        -e 's|../wrappers/bun\.|../wrappers/nodejs-tools/bun.|g' \
        -e 's|../wrappers/pip\.|../wrappers/python-tools/pip.|g' \
        -e 's|../wrappers/grep\.|../wrappers/search-tools/grep.|g' \
        -e 's|../wrappers/ag\.|../wrappers/search-tools/ag.|g' \
        -e 's|../wrappers/git-grep\.|../wrappers/search-tools/git-grep.|g' \
        -e 's|../wrappers/ucg\.|../wrappers/search-tools/ucg.|g' \
        -e 's|../wrappers/pt\.|../wrappers/search-tools/pt.|g' \
        -e 's|../wrappers/sift\.|../wrappers/search-tools/sift.|g' \
        -e 's|../wrappers/utils/|../wrappers/utils/|g' \
        -e 's|../wrappers/curl\.|../wrappers/system-tools/curl.|g' \
        -e 's|../wrappers/node\.|../wrappers/system-tools/node.|g' \
        "$nix_file"
    
    echo "  Updated: $nix_file"
    
    # Remove backup file
    rm -f "$nix_file.bak"
done

echo " All Nix derivations updated successfully!"
