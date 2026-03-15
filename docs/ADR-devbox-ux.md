---
modeline: "vim: set ft=markdown:"
title: "ADR: Command Governance Integration with Standard Developer UX Flow"
adr-id: adr-20260314001
slug: 20260314001-command-governance-devbox-ux
url: /docs/ADR-devbox-ux.md
synopsis: Integrate Command Preference & Package Governance System with Devbox-first developer workflow without disrupting established patterns
author: https://github.com/levonk
date-created: 2026-03-14
date-updated: 2026-03-14
version: 1.0.0
status: "implemented"
aliases: []
tags: ["doc/architecture/adr", "command-governance", "devbox", "developer-experience", "package-management"]
supersedes: []
superseded-by: []
related-to: ["adr-20260131001-standard-developer-ux-flow"]
---

## Context

The Command Preference & Package Governance System provides unified cross-ecosystem command governance through micro-packages that override developer commands (npm, pip, curl, etc.) with policy-aware wrappers. This system needs to integrate seamlessly with the established Standard Developer UX Flow (Devbox-first) defined in ADR-20260131001.

The governance system must:
1. Work within the existing `direnv → devbox → just (*-internal) → cargo` flow
2. Not interfere with Devbox scripts and justfile targets
3. Support both individual package installation and bundle installation
4. Maintain compatibility with automated systems and CI/CD pipelines
5. Preserve the developer experience established by the standard workflow

## Decision

### Primary Integration: Devbox Package Addition

The Command Governance System integrates with the Devbox-first workflow through standard Devbox package addition:

```bash
# Individual governance packages
devbox add github:levonk/levonk-packages#prefer-pnpm
devbox add github:levonk/levonk-packages#force-pnpm
devbox add github:levonk/levonk-packages#block-npm

# Bundle package for comprehensive governance
devbox add github:levonk/levonk-packages#command-governance
```

### Workflow Integration Points

#### 1. Environment Setup (direnv → devbox)
- **No changes required**: Governance packages are installed like any other Devbox package
- **Automatic activation**: Governed commands are available immediately when devbox environment activates
- **PATH manipulation**: Governance packages shadow original commands through standard Nix PATH precedence

#### 2. Command Execution (devbox → just (*-internal))
- **Transparent integration**: Governed commands work within justfile recipes without modification
- **Wrapper execution**: Policy enforcement happens automatically when commands are invoked
- **Error handling**: Failed governance (blocked commands) propagate naturally through just execution

#### 3. Automated Systems (CI/CD, init_hooks)
- **No interference**: Governance packages don't conflict with Devbox init_hook calling just *-internal targets
- **Predictable behavior**: Wrapper scripts provide consistent behavior across manual and automated execution
- **Exit codes**: Standard exit codes work with existing automation patterns

### Devbox Configuration Integration

#### Standard Devbox.json with Governance
```json
{
  "name": "project-with-governance",
  "packages": [
    "nodejs",
    "pnpm",
    "github:levonk/levonk-packages#prefer-pnpm"
  ],
  "shell": {
    "init_hook": [
      "just bootstrap-internal"
    ]
  },
  "scripts": {
    "bootstrap": "just bootstrap-internal",
    "build": "just build-internal",
    "test": "just test-internal",
    "dev": "just dev-internal"
  }
}
```

#### Bundle Configuration
```json
{
  "name": "project-with-full-governance",
  "packages": [
    "nodejs",
    "pnpm",
    "github:levonk/levonk-packages#command-governance"
  ],
  "shell": {
    "init_hook": [
      "just bootstrap-internal"
    ]
  },
  "scripts": {
    "bootstrap": "just bootstrap-internal",
    "build": "just build-internal",
    "test": "just test-internal",
    "dev": "just dev-internal"
  }
}
```

### justfile Integration Patterns

#### Standard justfile (No Changes Required)
```just
# Standard targets work unchanged with governance
build:
    devbox shell build

test:
    devbox shell test

dev:
    devbox shell dev

# Internal targets work unchanged
build-internal:
    npm run build  # Will be governed by prefer-pnpm/force-pnpm/block-npm

test-internal:
    npm test      # Will be governed by prefer-pnpm/force-pnpm/block-npm

dev-internal:
    npm run dev   # Will be governed by prefer-pnpm/force-pnpm/block-npm
```

#### Governance-Aware justfile (Optional Enhancements)
```just
# Add governance-specific targets
governance-status:
    @echo "🔍 Command Governance Status:"
    @which npm && npm --version || echo "npm: governed"
    @which pip && pip --version || echo "pip: governed"

governance-test:
    # Test that governance is working
    @echo "Testing npm governance..."
    @npm --version || echo "✅ npm governance active"

# Standard targets unchanged
build:
    devbox shell build
```

## Rationale

### Why Devbox Package Addition

1. **Zero Configuration**: Governance packages install like any other Devbox package
2. **Standard Patterns**: Uses existing Devbox workflows without new concepts
3. **Path Precedence**: Nix package management automatically handles command shadowing
4. **Environment Isolation**: Governance applies only within Devbox environment
5. **Rollback Support**: Easy to remove governance packages by removing from devbox.json

### Why No Workflow Changes Required

1. **Wrapper Transparency**: Governance wrappers act like normal commands from workflow perspective
2. **Exit Code Preservation**: Standard exit codes work with existing error handling
3. **Argument Passing**: All command arguments pass through unchanged
4. **Output Compatibility**: Governed commands produce compatible output for tooling

### Why Bundle Package Support

1. **Comprehensive Governance**: Single package for full command governance
2. **Simplified Management**: One addition to devbox.json for complete coverage
3. **Consistent Versioning**: Bundle ensures all governance packages work together
4. **Easy Onboarding**: Simple for teams to adopt comprehensive governance

## Consequences

### Positive

1. **Seamless Integration**: No changes required to existing workflows
2. **Gradual Adoption**: Teams can adopt governance incrementally
3. **Developer Experience**: No cognitive overhead beyond standard Devbox usage
4. **Automation Compatibility**: CI/CD and scripts work without modification
5. **Rollback Safety**: Easy to disable governance by removing packages

### Negative

1. **Package Discovery**: Developers need to learn about governance packages
2. **Debugging Complexity**: Command behavior changes may require investigation
3. **Dependency Management**: Governance packages add to dependency tree
4. **Version Coordination**: Bundle package may update individual governance packages

### Neutral

1. **Performance**: Minimal overhead from wrapper scripts
2. **Compatibility**: Works with all existing tools and integrations
3. **Maintenance**: Governance packages require updates like any other dependency

## Implementation

### Package Structure

All governance packages follow the Nix derivation pattern:

```nix
{ pkgs }:
let
  preferredTool = pkgs.pnpm;  # or other preferred tool
in
pkgs.writeShellScriptBin "npm" ''
  echo "⚠️ Prefer pnpm over npm. Running pnpm instead..."
  exec ${preferredTool}/bin/pnpm "$@"
''
```

### Integration Testing

The implementation includes comprehensive testing:

```bash
# Test individual packages
nix build .#prefer-pnpm
nix run .#prefer-pnpm -- --version

# Test bundle package
nix build .#command-governance

# Test Devbox integration
devbox add .#prefer-pnpm
npm --version  # Should show governance behavior
```

### Documentation Integration

- **SPEC.md**: Complete technical specification
- **ADR-devbox-ux.md**: This integration document
- **README.md**: Quick start guide and examples
- **Package docs**: Individual package documentation

## Migration Strategy

### Phase 1: Documentation and Testing (Week 1)
- Complete integration testing
- Document integration patterns
- Create migration guides

### Phase 2: Pilot Projects (Week 2)
- Apply governance to pilot projects
- Validate workflow compatibility
- Collect developer feedback

### Phase 3: Team Adoption (Month 1)
- Roll out to additional teams
- Provide training and support
- Refine based on feedback

### Phase 4: Organization Adoption (Month 2)
- Standardize governance across projects
- Integrate with project templates
- Establish governance policies

## Usage Examples

### Individual Package Adoption
```bash
# Project setup
cd my-project
devbox init
devbox add nodejs pnpm

# Add npm governance
devbox add github:levonk/levonk-packages#prefer-pnpm

# Standard workflow continues unchanged
just build
just test
just dev
```

### Bundle Package Adoption
```bash
# Project setup with comprehensive governance
cd my-project
devbox init
devbox add nodejs pnpm
devbox add github:levonk/levonk-packages#command-governance

# All governed commands now active
npm install    # Governed
pip install     # Governed
curl request    # Governed
```

### CI/CD Integration
```yaml
# GitHub Actions example
- uses: jetify-com/devbox-action@v0
- run: devbox run just test
  # npm commands within tests are automatically governed
```

## Success Metrics

- **Adoption Rate**: 80% of projects using governance within 3 months
- **Developer Satisfaction**: No increase in support tickets related to governance
- **Workflow Compatibility**: 100% compatibility with existing justfile targets
- **CI/CD Reliability**: No increase in build failures due to governance
- **Policy Compliance**: 90% reduction in usage of disfavored tools

## References

- [Command Governance SPEC](./SPEC.md)
- [Standard Developer UX Flow ADR](https://github.com/lrepo52/job-aide/blob/main/internal-docs/adr/adr-20260131001-standard-developer-ux-flow.md)
- [Devbox Documentation](https://www.jetify.com/devbox/docs)
- [just Command Runner](https://github.com/casey/just)
- [Nix Package Manager](https://nixos.org/)

<!-- vim: set ft=markdown: -->
