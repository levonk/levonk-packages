#!/usr/bin/env sh
echo "🚀 Ejecting pt (the_platinum_searcher) in favor of ripgrep..."
echo "💡 To install ripgrep: https://burntsushi.net/ripgrep/"
echo "🔄 Running ripgrep..."
exec rg "$@"
