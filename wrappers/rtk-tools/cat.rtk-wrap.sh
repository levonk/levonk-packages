#!/usr/bin/env bash
# RTK wrapper for cat command (uses rtk read)
# Transparently runs cat through RTK read for token-optimized output
#
# Bypass RTK when cat is used without file arguments (e.g. `cat > file <<EOF`
# or `echo foo | cat > file`). In that mode cat is a write/pipe tool, not a
# file reader, and `rtk read` would swallow stdin and produce no output.
# `rtk read` only adds value when reading named files.

if [ "$#" -eq 0 ]; then
    # No file arguments — stdin-to-stdout mode. Bypass RTK, use native cat.
    exec "$NATIVE_BIN" "$@"
fi
