# Handoff: Devbox Reminder Packages Refactor

## Completed
- 4 generic wrapper scripts in `wrappers/devbox-reminders/` (argv[0] dispatch)
- 92 Nix derivations regenerated with `REAL_TOOL` set before sourcing generic scripts
- `flake.nix` updated (89 unique packages after removing 3 duplicates)
- Test directories: `tests/devbox-reminders/{prefer,force,block,eject}/`
- `AGENTS.md` updated with test docs

## Verified
```bash
nix run .#prefer-cargo -- --version   # works, shows reminder + cargo version
nix run .#block-cargo -- --version    # works, exit 1, shows block message
```

## Remaining Issues
1. `nix flake check` stack overflow on evaluating all 200+ packages at once
2. 3 duplicate attributes removed from flake.nix: `prefer-uv`, `block-pip`, `eject-pip` (conflict with existing Python governance)
3. Force/eject tests not fully run yet
4. Need to run full test suite: `cd tests/devbox-reminders/<variant> && devbox shell`

## Next Steps
- Fix `nix flake check` (consider splitting flake or reducing package count)
- Rename conflicting packages if devbox reminders needed for pip/uv too
- Run all 4 test variants and fix any failures
