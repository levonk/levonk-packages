#!/usr/bin/env sh
echo "🚀 Ejecting grep in favor of ripgrep..."
echo "💡 To install ripgrep: https://burntsushi.net/ripgrep/"
echo "🔄 Running ripgrep..."
exec rg "$@"
