#!/usr/bin/env sh
echo "🚀 Ejecting ag (the_silver_searcher) in favor of ripgrep..."
echo "💡 To install ripgrep: https://burntsushi.net/ripgrep/"
echo "🔄 Running ripgrep..."
exec rg "$@"
