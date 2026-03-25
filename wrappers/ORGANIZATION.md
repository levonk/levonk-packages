# Wrapper Organization Strategy

## Current Problem
- 71+ wrapper files in flat directory
- Mixed tool types (Node.js, Python, Search tools)
- No clear categorization
- Hard to find specific tools

## Proposed Organization

```
wrappers/
├── nodejs-tools/           # Node.js package managers
│   ├── npm/
│   │   ├── prefer-pnpm.sh
│   │   ├── prefer-yarn.sh
│   │   ├── prefer-bun.sh
│   │   ├── eject-npm.sh
│   │   ├── force-pnpm.sh
│   │   └── block-npm.sh
│   ├── pnpm/
│   │   ├── prefer-npm.sh
│   │   ├── prefer-yarn.sh
│   │   └── ...
│   ├── yarn/
│   └── bun/
├── python-tools/           # Python package managers
│   ├── pip/
│   │   ├── prefer-uv.sh
│   │   ├── eject-pip.sh
│   │   └── block-pip.sh
│   └── ...
├── search-tools/           # Search tools
│   ├── grep/
│   │   ├── prefer-ripgrep.sh
│   │   ├── force-grep.sh
│   │   ├── block-grep.sh
│   │   └── eject-grep.sh
│   ├── ag/
│   ├── git-grep/
│   ├── ucg/
│   ├── pt/
│   └── sift/
├── system-tools/           # System tools
│   ├── curl/
│   │   └── prefer-devbox.sh
│   └── node/
│       └── prefer-corepack.sh
└── utils/                 # Shared utilities
    └── detect-packages.sh
```

## Migration Status

✅ **COMPLETED** - Migration completed on 2026-03-24

**Changes Made:**
- ✅ Created new directory structure with kebab-case naming
- ✅ Moved all wrapper files using `git mv` to preserve history
- ✅ Updated all Nix derivations to use new paths
- ✅ Verified package builds work correctly
- ✅ Maintained file git history through proper moves

**Final Structure:**
```
wrappers/
├── nodejs-tools/     (46 files) - npm, pnpm, yarn, bun packages
├── python-tools/     (3 files)  - pip packages  
├── search-tools/     (24 files) - grep, ag, git-grep, ucg, pt, sift packages
├── system-tools/     (2 files)  - curl, node packages
└── utils/            (empty)    - shared utilities
```

## Benefits

- **Logical grouping** by tool ecosystem
- **Scalable** for new tool categories
- **Easy navigation** and maintenance
- **Clear ownership** boundaries
- **Consistent naming** with kebab-case convention

## Migration Commands Used

```bash
# Create directories
mkdir -p wrappers/nodejs-tools wrappers/python-tools wrappers/search-tools wrappers/system-tools wrappers/utils

# Move files with git mv to preserve history
cd wrappers && git mv npm.* nodejs-tools/
cd wrappers && git mv pnpm.* nodejs-tools/
cd wrappers && git mv yarn.* nodejs-tools/
cd wrappers && git mv bun.* nodejs-tools/
cd wrappers && git mv pip.* python-tools/
cd wrappers && git mv grep.* search-tools/
cd wrappers && git mv ag.* search-tools/
cd wrappers && git mv git-grep.* search-tools/
cd wrappers && git mv ucg.* search-tools/
cd wrappers && git mv pt.* search-tools/
cd wrappers && git mv sift.* search-tools/
cd wrappers && git mv curl.* system-tools/
cd wrappers && git mv node.* system-tools/

# Update all Nix derivations automatically
./scripts/update-nix-paths.sh
