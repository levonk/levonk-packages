#!/usr/bin/env bats
# Tests for the _wrapper_path_excluding_self helper and is_package_available
# recursion fix in wrappers/utils/devbox-manager.sh.
#
# Background: is_package_available() previously did a bare `command -v $tool`
# without excluding the wrapper's own bin directory from PATH. When a wrapper
# package (e.g. devbox-rtk-nodejs-pnpm-dlx-force) was installed, its own
# `pnpm` symlink sat in PATH, so devbox_wrap pnpm dlx "$@" re-entered the
# wrapper → infinite recursion.
#
# These tests build a real wrapper package, stage a fake "real" tool on PATH
# in front of the wrapper, and assert the wrapper execs the fake tool
# (proving it skipped its own symlink) and terminates within a timeout.

# Bash-native timeout: run a command in the background, kill it after N
# seconds. Returns the command's exit status, or 124 on timeout.
_timeout_cmd() {
    local secs="$1"
    shift
    ( "$@" ) &
    local pid=$!
    ( sleep "$secs" && kill "$pid" 2>/dev/null ) &
    local watcher=$!
    wait "$pid" 2>/dev/null
    local status=$?
    kill "$watcher" 2>/dev/null
    wait "$watcher" 2>/dev/null
    if [ "$status" -eq 0 ] || [ "$status" -eq 1 ]; then
        return "$status"
    fi
    # 124 = timeout (killed by watcher)
    return 124
}

setup() {
    PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PROJECT_ROOT
}

# Build a wrapper package once per test file and cache its store path.
_build_wrapper() {
    local pkg="$1"
    local cache_var="_BUILT_${pkg//-/_}"
    if eval "[ -z \"\${$cache_var:-}\" ]"; then
        local path
        path="$(nix build ".#$pkg" --no-link --print-out-paths 2>/dev/null | tail -1)"
        eval "export $cache_var=\"\$path\""
    fi
    eval "printf '%s' \"\${$cache_var}\""
}

# Stage a fake tool that records its args and exits 0. Returns the bin dir
# via stdout; caller captures into FAKE_BIN_DIR.
_stage_fake_tool() {
    local tool="$1"
    local dir
    dir="$(mktemp -d)"
    cat > "$dir/$tool" <<EOF
#!/usr/bin/env bash
echo "FAKE $tool CALLED WITH: \$*"
EOF
    chmod +x "$dir/$tool"
    printf '%s' "$dir"
}

teardown() {
    # Use `if` rather than `[ -n ... ] && ...` because bats runs with set -e
    # and a false `[ -n "" ]` would abort teardown, masking real failures.
    if [ -n "${FAKE_BIN_DIR:-}" ]; then rm -rf "$FAKE_BIN_DIR"; fi
    if [ -n "${FAKE_BIN_DIR_2:-}" ]; then rm -rf "$FAKE_BIN_DIR_2"; fi
}

@test "devbox-rtk-nodejs-pnpm-dlx-force: npx redirects to real pnpm dlx, not its own symlink (no recursion)" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"

    # PATH: fake pnpm FIRST, wrapper bin SECOND, /usr/bin:/bin for basics.
    # If is_package_available is broken, the wrapper's own pnpm symlink
    # would be found (it's in $wrapper_path/bin) and exec pnpm dlx would
    # re-enter the wrapper → infinite recursion → timeout (exit 124).
    export PATH="$FAKE_BIN_DIR:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/npx" create-next-app myapp

    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx create-next-app myapp"* ]]
}

@test "devbox-rtk-nodejs-pnpm-dlx-force: bunx redirects to real pnpm dlx" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"

    export PATH="$FAKE_BIN_DIR:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/bunx" create-vite

    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx create-vite"* ]]
}

@test "devbox-rtk-nodejs-pnpm-dlx-force: yarn dlx redirects to real pnpm dlx" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    FAKE_BIN_DIR_2="$(_stage_fake_tool yarn)"

    export PATH="$FAKE_BIN_DIR:$FAKE_BIN_DIR_2:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/yarn" dlx cowsay hi

    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx cowsay hi"* ]]
}

@test "devbox-rtk-nodejs-pnpm-dlx-force: bun x redirects to real pnpm dlx" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    FAKE_BIN_DIR_2="$(_stage_fake_tool bun)"

    export PATH="$FAKE_BIN_DIR:$FAKE_BIN_DIR_2:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/bun" x cowsay hi

    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx cowsay hi"* ]]
}

@test "devbox-rtk-nodejs-pnpm-dlx-force: yarn install (non-dlx) passes through to yarn" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    FAKE_BIN_DIR_2="$(_stage_fake_tool yarn)"

    export PATH="$FAKE_BIN_DIR:$FAKE_BIN_DIR_2:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/yarn" install

    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE yarn CALLED WITH: install"* ]]
}

@test "devbox-rtk-nodejs-pnpm-dlx-force: bun install (non-x) passes through to bun" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    FAKE_BIN_DIR_2="$(_stage_fake_tool bun)"

    export PATH="$FAKE_BIN_DIR:$FAKE_BIN_DIR_2:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/bun" install

    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE bun CALLED WITH: install"* ]]
}

@test "devbox-rtk-nodejs-pnpm-dlx-block: npx is blocked with exit 1" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-block)"

    export PATH="$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/npx" create-next-app myapp

    [ "$status" -eq 1 ]
    [[ "$output" == *"npx is blocked by policy"* ]]
}

@test "devbox-rtk-nodejs-pnpm-dlx-block: yarn dlx is blocked but yarn install passes through" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-block)"
    FAKE_BIN_DIR="$(_stage_fake_tool yarn)"

    export PATH="$FAKE_BIN_DIR:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/yarn" dlx cowsay hi
    [ "$status" -eq 1 ]
    [[ "$output" == *"yarn dlx is blocked by policy"* ]]

    run _timeout_cmd 10 "$wrapper_path/bin/yarn" install
    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE yarn CALLED WITH: install"* ]]
}

# --- Flag translation tests (npx → pnpm dlx) ---

@test "flag translation: npx --yes foo → pnpm dlx foo (--yes dropped)" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    export PATH="$FAKE_BIN_DIR:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/npx" --yes create-next-app myapp
    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx create-next-app myapp"* ]]
    [[ "$output" != *"--yes"* ]]
}

@test "flag translation: npx -y foo → pnpm dlx foo (-y dropped)" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    export PATH="$FAKE_BIN_DIR:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/npx" -y create-next-app myapp
    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx create-next-app myapp"* ]]
    [[ "$output" != *"-y "* ]]
}

@test "flag translation: npx -p pkg foo → pnpm dlx --package pkg foo" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    export PATH="$FAKE_BIN_DIR:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/npx" -p cowsay cowsay hi
    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx --package cowsay cowsay hi"* ]]
}

@test "flag translation: npx --package pkg foo → passthrough" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    export PATH="$FAKE_BIN_DIR:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/npx" --package cowsay cowsay hi
    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx --package cowsay cowsay hi"* ]]
}

@test "flag translation: npx -y -p pkg foo → pnpm dlx --package pkg foo" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    export PATH="$FAKE_BIN_DIR:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/npx" -y -p cowsay cowsay hi
    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx --package cowsay cowsay hi"* ]]
    [[ "$output" != *"-y "* ]]
    [[ "$output" != *"--yes"* ]]
}

@test "flag translation: npx --no foo → --no dropped" {
    wrapper_path="$(_build_wrapper devbox-rtk-nodejs-pnpm-dlx-force)"
    FAKE_BIN_DIR="$(_stage_fake_tool pnpm)"
    export PATH="$FAKE_BIN_DIR:$wrapper_path/bin:/usr/bin:/bin"

    run _timeout_cmd 10 "$wrapper_path/bin/npx" --no create-next-app myapp
    [ "$status" -eq 0 ]
    [[ "$output" == *"FAKE pnpm CALLED WITH: dlx create-next-app myapp"* ]]
    [[ "$output" != *"--no "* ]]
}
