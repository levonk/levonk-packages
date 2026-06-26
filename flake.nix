{
  description = "Command Preference & Package Governance System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nub.url = "github:nubjs/nub";
  };

  outputs = { self, nixpkgs, flake-utils, nub }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nub-pkg = nub.packages.${system}.nub;
        
        # Import all packages
        prefer-pnpm = import ./nix/prefer-pnpm.nix { inherit pkgs; };
        eject-npm = import ./nix/eject-npm.nix { inherit pkgs; };
        force-pnpm = import ./nix/force-pnpm.nix { inherit pkgs; };
        block-npm = import ./nix/block-npm.nix { inherit pkgs; };
        prefer-yarn = import ./nix/prefer-yarn.nix { inherit pkgs; };
        eject-yarn = import ./nix/eject-yarn.nix { inherit pkgs; };
        force-yarn = import ./nix/force-yarn.nix { inherit pkgs; };
        block-yarn = import ./nix/block-yarn.nix { inherit pkgs; };
        prefer-bun = import ./nix/prefer-bun.nix { inherit pkgs; };
        eject-bun = import ./nix/eject-bun.nix { inherit pkgs; };
        force-bun = import ./nix/force-bun.nix { inherit pkgs; };
        block-bun = import ./nix/block-bun.nix { inherit pkgs; };
        prefer-uv = import ./nix/prefer-uv.nix { inherit pkgs; };
        eject-pip = import ./nix/eject-pip.nix { inherit pkgs; };
        block-pip = import ./nix/block-pip.nix { inherit pkgs; };
        prefer-npm = import ./nix/prefer-npm.nix { inherit pkgs; };
        force-npm = import ./nix/force-npm.nix { inherit pkgs; };
        eject-pnpm = import ./nix/eject-pnpm.nix { inherit pkgs; };
        block-pnpm = import ./nix/block-pnpm.nix { inherit pkgs; };
        prefer-yarn-from-pnpm = import ./nix/prefer-yarn-from-pnpm.nix { inherit pkgs; };
        force-yarn-from-pnpm = import ./nix/force-yarn-from-pnpm.nix { inherit pkgs; };
        block-yarn-from-pnpm = import ./nix/block-yarn-from-pnpm.nix { inherit pkgs; };
        eject-yarn-from-pnpm = import ./nix/eject-yarn-from-pnpm.nix { inherit pkgs; };
        prefer-bun-from-pnpm = import ./nix/prefer-bun-from-pnpm.nix { inherit pkgs; };
        force-bun-from-pnpm = import ./nix/force-bun-from-pnpm.nix { inherit pkgs; };
        block-bun-from-pnpm = import ./nix/block-bun-from-pnpm.nix { inherit pkgs; };
        eject-bun-from-pnpm = import ./nix/eject-bun-from-pnpm.nix { inherit pkgs; };
        prefer-npm-from-yarn = import ./nix/prefer-npm-from-yarn.nix { inherit pkgs; };
        force-npm-from-yarn = import ./nix/force-npm-from-yarn.nix { inherit pkgs; };
        block-npm-from-yarn = import ./nix/block-npm-from-yarn.nix { inherit pkgs; };
        eject-npm-from-yarn = import ./nix/eject-npm-from-yarn.nix { inherit pkgs; };
        prefer-pnpm-from-yarn = import ./nix/prefer-pnpm-from-yarn.nix { inherit pkgs; };
        force-pnpm-from-yarn = import ./nix/force-pnpm-from-yarn.nix { inherit pkgs; };
        block-pnpm-from-yarn = import ./nix/block-pnpm-from-yarn.nix { inherit pkgs; };
        eject-pnpm-from-yarn = import ./nix/eject-pnpm-from-yarn.nix { inherit pkgs; };
        prefer-bun-from-yarn = import ./nix/prefer-bun-from-yarn.nix { inherit pkgs; };
        force-bun-from-yarn = import ./nix/force-bun-from-yarn.nix { inherit pkgs; };
        block-bun-from-yarn = import ./nix/block-bun-from-yarn.nix { inherit pkgs; };
        eject-bun-from-yarn = import ./nix/eject-bun-from-yarn.nix { inherit pkgs; };
        prefer-npm-from-bun = import ./nix/prefer-npm-from-bun.nix { inherit pkgs; };
        force-npm-from-bun = import ./nix/force-npm-from-bun.nix { inherit pkgs; };
        block-npm-from-bun = import ./nix/block-npm-from-bun.nix { inherit pkgs; };
        eject-npm-from-bun = import ./nix/eject-npm-from-bun.nix { inherit pkgs; };
        prefer-pnpm-from-bun = import ./nix/prefer-pnpm-from-bun.nix { inherit pkgs; };
        force-pnpm-from-bun = import ./nix/force-pnpm-from-bun.nix { inherit pkgs; };
        block-pnpm-from-bun = import ./nix/block-pnpm-from-bun.nix { inherit pkgs; };
        eject-pnpm-from-bun = import ./nix/eject-pnpm-from-bun.nix { inherit pkgs; };
        prefer-yarn-from-bun = import ./nix/prefer-yarn-from-bun.nix { inherit pkgs; };
        force-yarn-from-bun = import ./nix/force-yarn-from-bun.nix { inherit pkgs; };
        block-yarn-from-bun = import ./nix/block-yarn-from-bun.nix { inherit pkgs; };
        eject-yarn-from-bun = import ./nix/eject-yarn-from-bun.nix { inherit pkgs; };
        prefer-devbox = import ./nix/prefer-devbox.nix { inherit pkgs; };
        prefer-corepack = import ./nix/prefer-corepack.nix { inherit pkgs; };
        
        # Search tool governance packages
        prefer-grep = import ./nix/prefer-grep.nix { inherit pkgs; };
        eject-grep = import ./nix/eject-grep.nix { inherit pkgs; };
        force-grep = import ./nix/force-grep.nix { inherit pkgs; };
        block-grep = import ./nix/block-grep.nix { inherit pkgs; };
        prefer-ag = import ./nix/prefer-ag.nix { inherit pkgs; };
        eject-ag = import ./nix/eject-ag.nix { inherit pkgs; };
        force-ag = import ./nix/force-ag.nix { inherit pkgs; };
        block-ag = import ./nix/block-ag.nix { inherit pkgs; };
        prefer-git-grep = import ./nix/prefer-git-grep.nix { inherit pkgs; };
        eject-git-grep = import ./nix/eject-git-grep.nix { inherit pkgs; };
        force-git-grep = import ./nix/force-git-grep.nix { inherit pkgs; };
        block-git-grep = import ./nix/block-git-grep.nix { inherit pkgs; };
        prefer-ucg = import ./nix/prefer-ucg.nix { inherit pkgs; };
        eject-ucg = import ./nix/eject-ucg.nix { inherit pkgs; };
        force-ucg = import ./nix/force-ucg.nix { inherit pkgs; };
        block-ucg = import ./nix/block-ucg.nix { inherit pkgs; };
        prefer-pt = import ./nix/prefer-pt.nix { inherit pkgs; };
        eject-pt = import ./nix/eject-pt.nix { inherit pkgs; };
        force-pt = import ./nix/force-pt.nix { inherit pkgs; };
        block-pt = import ./nix/block-pt.nix { inherit pkgs; };
        prefer-sift = import ./nix/prefer-sift.nix { inherit pkgs; };
        eject-sift = import ./nix/eject-sift.nix { inherit pkgs; };
        force-sift = import ./nix/force-sift.nix { inherit pkgs; };
        block-sift = import ./nix/block-sift.nix { inherit pkgs; };
        

        # Devbox reminder governance packages
        prefer-cargo = import ./nix/prefer-cargo.nix { inherit pkgs; };
        force-cargo = import ./nix/force-cargo.nix { inherit pkgs; };
        block-cargo = import ./nix/block-cargo.nix { inherit pkgs; };
        eject-cargo = import ./nix/eject-cargo.nix { inherit pkgs; };
        prefer-rustc = import ./nix/prefer-rustc.nix { inherit pkgs; };
        force-rustc = import ./nix/force-rustc.nix { inherit pkgs; };
        block-rustc = import ./nix/block-rustc.nix { inherit pkgs; };
        eject-rustc = import ./nix/eject-rustc.nix { inherit pkgs; };
        prefer-tsc = import ./nix/prefer-tsc.nix { inherit pkgs; };
        force-tsc = import ./nix/force-tsc.nix { inherit pkgs; };
        block-tsc = import ./nix/block-tsc.nix { inherit pkgs; };
        eject-tsc = import ./nix/eject-tsc.nix { inherit pkgs; };
        prefer-node = import ./nix/prefer-node.nix { inherit pkgs; };
        force-node = import ./nix/force-node.nix { inherit pkgs; };
        block-node = import ./nix/block-node.nix { inherit pkgs; };
        eject-node = import ./nix/eject-node.nix { inherit pkgs; };
        prefer-python3 = import ./nix/prefer-python3.nix { inherit pkgs; };
        force-python3 = import ./nix/force-python3.nix { inherit pkgs; };
        block-python3 = import ./nix/block-python3.nix { inherit pkgs; };
        eject-python3 = import ./nix/eject-python3.nix { inherit pkgs; };
        prefer-python = import ./nix/prefer-python.nix { inherit pkgs; };
        force-python = import ./nix/force-python.nix { inherit pkgs; };
        block-python = import ./nix/block-python.nix { inherit pkgs; };
        eject-python = import ./nix/eject-python.nix { inherit pkgs; };
        prefer-pip = import ./nix/prefer-pip.nix { inherit pkgs; };
        force-pip = import ./nix/force-pip.nix { inherit pkgs; };
        prefer-pip3 = import ./nix/prefer-pip3.nix { inherit pkgs; };
        force-pip3 = import ./nix/force-pip3.nix { inherit pkgs; };
        block-pip3 = import ./nix/block-pip3.nix { inherit pkgs; };
        eject-pip3 = import ./nix/eject-pip3.nix { inherit pkgs; };
        force-uv = import ./nix/force-uv.nix { inherit pkgs; };
        block-uv = import ./nix/block-uv.nix { inherit pkgs; };
        eject-uv = import ./nix/eject-uv.nix { inherit pkgs; };
        prefer-java = import ./nix/prefer-java.nix { inherit pkgs; };
        force-java = import ./nix/force-java.nix { inherit pkgs; };
        block-java = import ./nix/block-java.nix { inherit pkgs; };
        eject-java = import ./nix/eject-java.nix { inherit pkgs; };
        prefer-javac = import ./nix/prefer-javac.nix { inherit pkgs; };
        force-javac = import ./nix/force-javac.nix { inherit pkgs; };
        block-javac = import ./nix/block-javac.nix { inherit pkgs; };
        eject-javac = import ./nix/eject-javac.nix { inherit pkgs; };
        prefer-go = import ./nix/prefer-go.nix { inherit pkgs; };
        force-go = import ./nix/force-go.nix { inherit pkgs; };
        block-go = import ./nix/block-go.nix { inherit pkgs; };
        eject-go = import ./nix/eject-go.nix { inherit pkgs; };
        prefer-swift = import ./nix/prefer-swift.nix { inherit pkgs; };
        force-swift = import ./nix/force-swift.nix { inherit pkgs; };
        block-swift = import ./nix/block-swift.nix { inherit pkgs; };
        eject-swift = import ./nix/eject-swift.nix { inherit pkgs; };
        prefer-make = import ./nix/prefer-make.nix { inherit pkgs; };
        force-make = import ./nix/force-make.nix { inherit pkgs; };
        block-make = import ./nix/block-make.nix { inherit pkgs; };
        eject-make = import ./nix/eject-make.nix { inherit pkgs; };
        prefer-cmake = import ./nix/prefer-cmake.nix { inherit pkgs; };
        force-cmake = import ./nix/force-cmake.nix { inherit pkgs; };
        block-cmake = import ./nix/block-cmake.nix { inherit pkgs; };
        eject-cmake = import ./nix/eject-cmake.nix { inherit pkgs; };
        prefer-ninja = import ./nix/prefer-ninja.nix { inherit pkgs; };
        force-ninja = import ./nix/force-ninja.nix { inherit pkgs; };
        block-ninja = import ./nix/block-ninja.nix { inherit pkgs; };
        eject-ninja = import ./nix/eject-ninja.nix { inherit pkgs; };
        prefer-just = import ./nix/prefer-just.nix { inherit pkgs; };
        force-just = import ./nix/force-just.nix { inherit pkgs; };
        block-just = import ./nix/block-just.nix { inherit pkgs; };
        eject-just = import ./nix/eject-just.nix { inherit pkgs; };
        prefer-gcc = import ./nix/prefer-gcc.nix { inherit pkgs; };
        force-gcc = import ./nix/force-gcc.nix { inherit pkgs; };
        block-gcc = import ./nix/block-gcc.nix { inherit pkgs; };
        eject-gcc = import ./nix/eject-gcc.nix { inherit pkgs; };
        prefer-gpp = import ./nix/prefer-g++.nix { inherit pkgs; };
        force-gpp = import ./nix/force-g++.nix { inherit pkgs; };
        block-gpp = import ./nix/block-g++.nix { inherit pkgs; };
        eject-gpp = import ./nix/eject-g++.nix { inherit pkgs; };
        prefer-clang = import ./nix/prefer-clang.nix { inherit pkgs; };
        force-clang = import ./nix/force-clang.nix { inherit pkgs; };
        block-clang = import ./nix/block-clang.nix { inherit pkgs; };
        eject-clang = import ./nix/eject-clang.nix { inherit pkgs; };
        prefer-dotnet = import ./nix/prefer-dotnet.nix { inherit pkgs; };
        force-dotnet = import ./nix/force-dotnet.nix { inherit pkgs; };
        block-dotnet = import ./nix/block-dotnet.nix { inherit pkgs; };
        eject-dotnet = import ./nix/eject-dotnet.nix { inherit pkgs; };
        prefer-ruby = import ./nix/prefer-ruby.nix { inherit pkgs; };
        force-ruby = import ./nix/force-ruby.nix { inherit pkgs; };
        block-ruby = import ./nix/block-ruby.nix { inherit pkgs; };
        eject-ruby = import ./nix/eject-ruby.nix { inherit pkgs; };
        prefer-gem = import ./nix/prefer-gem.nix { inherit pkgs; };
        force-gem = import ./nix/force-gem.nix { inherit pkgs; };
        block-gem = import ./nix/block-gem.nix { inherit pkgs; };
        eject-gem = import ./nix/eject-gem.nix { inherit pkgs; };
        
        # RTK wrapper packages
        rtk-wrap-ls = import ./nix/rtk-wrap-ls.nix { inherit pkgs; };
        rtk-wrap-tree = import ./nix/rtk-wrap-tree.nix { inherit pkgs; };
        rtk-wrap-git = import ./nix/rtk-wrap-git.nix { inherit pkgs; };
        rtk-wrap-grep = import ./nix/rtk-wrap-grep.nix { inherit pkgs; };
        rtk-wrap-find = import ./nix/rtk-wrap-find.nix { inherit pkgs; };
        rtk-wrap-cat = import ./nix/rtk-wrap-cat.nix { inherit pkgs; };
        rtk-wrap-npm = import ./nix/rtk-wrap-npm.nix { inherit pkgs; };
        rtk-wrap-npx = import ./nix/rtk-wrap-npx.nix { inherit pkgs; };
        rtk-wrap-tsc = import ./nix/rtk-wrap-tsc.nix { inherit pkgs; };
        rtk-wrap-jest = import ./nix/rtk-wrap-jest.nix { inherit pkgs; };
        rtk-wrap-vitest = import ./nix/rtk-wrap-vitest.nix { inherit pkgs; };
        rtk-wrap-pytest = import ./nix/rtk-wrap-pytest.nix { inherit pkgs; };
        rtk-wrap-mypy = import ./nix/rtk-wrap-mypy.nix { inherit pkgs; };
        rtk-wrap-ruff = import ./nix/rtk-wrap-ruff.nix { inherit pkgs; };
        rtk-wrap-prettier = import ./nix/rtk-wrap-prettier.nix { inherit pkgs; };
        rtk-wrap-eslint = import ./nix/rtk-wrap-eslint.nix { inherit pkgs; };
        rtk-wrap-gh = import ./nix/rtk-wrap-gh.nix { inherit pkgs; };
        rtk-wrap-diff = import ./nix/rtk-wrap-diff.nix { inherit pkgs; };
        rtk-wrap-curl = import ./nix/rtk-wrap-curl.nix { inherit pkgs; };
        rtk-wrap-wc = import ./nix/rtk-wrap-wc.nix { inherit pkgs; };
        rtk-wrap-docker = import ./nix/rtk-wrap-docker.nix { inherit pkgs; };
        rtk-wrap-kubectl = import ./nix/rtk-wrap-kubectl.nix { inherit pkgs; };
        rtk-wrap-cargo = import ./nix/rtk-wrap-cargo.nix { inherit pkgs; };
        rtk-wrap-pip = import ./nix/rtk-wrap-pip.nix { inherit pkgs; };
        rtk-wrap-dotnet = import ./nix/rtk-wrap-dotnet.nix { inherit pkgs; };
        rtk-wrap-aws = import ./nix/rtk-wrap-aws.nix { inherit pkgs; };
        rtk-wrap-psql = import ./nix/rtk-wrap-psql.nix { inherit pkgs; };
        rtk-wrap-json = import ./nix/rtk-wrap-json.nix { inherit pkgs; };
        rtk-wrap-env = import ./nix/rtk-wrap-env.nix { inherit pkgs; };
        rtk-wrap-deps = import ./nix/rtk-wrap-deps.nix { inherit pkgs; };
        rtk-wrap-test = import ./nix/rtk-wrap-test.nix { inherit pkgs; };
        rtk-wrap-err = import ./nix/rtk-wrap-err.nix { inherit pkgs; };
        rtk-wrap-pnpm = import ./nix/rtk-wrap-pnpm.nix { inherit pkgs; };
        rtk-wrap-prisma = import ./nix/rtk-wrap-prisma.nix { inherit pkgs; };
        rtk-wrap-next = import ./nix/rtk-wrap-next.nix { inherit pkgs; };
        rtk-wrap-lint = import ./nix/rtk-wrap-lint.nix { inherit pkgs; };
        rtk-wrap-format = import ./nix/rtk-wrap-format.nix { inherit pkgs; };
        rtk-wrap-playwright = import ./nix/rtk-wrap-playwright.nix { inherit pkgs; };
        rtk-wrap-glab = import ./nix/rtk-wrap-glab.nix { inherit pkgs; };
        rtk-wrap-wget = import ./nix/rtk-wrap-wget.nix { inherit pkgs; };
        rtk-wrap-go = import ./nix/rtk-wrap-go.nix { inherit pkgs; };
        rtk-wrap-gt = import ./nix/rtk-wrap-gt.nix { inherit pkgs; };
        rtk-wrap-golangci-lint = import ./nix/rtk-wrap-golangci-lint.nix { inherit pkgs; };
        rtk-wrap-rubocop = import ./nix/rtk-wrap-rubocop.nix { inherit pkgs; };
        rtk-wrap-rake = import ./nix/rtk-wrap-rake.nix { inherit pkgs; };
        rtk-wrap-rspec = import ./nix/rtk-wrap-rspec.nix { inherit pkgs; };
        rtk-wrap-oc = import ./nix/rtk-wrap-oc.nix { inherit pkgs; };
        rtk-wrap-gradlew = import ./nix/rtk-wrap-gradlew.nix { inherit pkgs; };
        
        # RTK bundle packages
        bundle-rtk-core = import ./nix/bundle-rtk-core.nix { inherit pkgs; };
        bundle-rtk-development = import ./nix/bundle-rtk-development.nix { inherit pkgs; };
        bundle-rtk-cloud = import ./nix/bundle-rtk-cloud.nix { inherit pkgs; };
        bundle-rtk-all = import ./nix/bundle-rtk-all.nix { inherit pkgs; };
        
        # Devbox auto-wrapper packages
        devbox-auto-npm = import ./nix/devbox-auto-npm.nix { inherit pkgs; };
        devbox-auto-pnpm = import ./nix/devbox-auto-pnpm.nix { inherit pkgs; };
        devbox-auto-yarn = import ./nix/devbox-auto-yarn.nix { inherit pkgs; };
        devbox-auto-python = import ./nix/devbox-auto-python.nix { inherit pkgs; };
        devbox-auto-pip = import ./nix/devbox-auto-pip.nix { inherit pkgs; };
        devbox-auto-cargo = import ./nix/devbox-auto-cargo.nix { inherit pkgs; };
        devbox-auto-rustc = import ./nix/devbox-auto-rustc.nix { inherit pkgs; };
        devbox-auto-go = import ./nix/devbox-auto-go.nix { inherit pkgs; };
        
        # Devbox auto bundle packages
        bundle-devbox-auto-nodejs = import ./nix/bundle-devbox-auto-nodejs.nix { inherit pkgs; };
        bundle-devbox-auto-python = import ./nix/bundle-devbox-auto-python.nix { inherit pkgs; };
        bundle-devbox-auto-rust = import ./nix/bundle-devbox-auto-rust.nix { inherit pkgs; };
        bundle-devbox-auto-go = import ./nix/bundle-devbox-auto-go.nix { inherit pkgs; };
        bundle-devbox-auto-all = import ./nix/bundle-devbox-auto-all.nix { inherit pkgs; };
        
        # Integrated devbox-rtk-governance packages
        devbox-rtk-nodejs-pnpm-force = import ./nix/devbox-rtk-nodejs-pnpm-force.nix { inherit pkgs; };
        devbox-rtk-nodejs-pnpm-prefer = import ./nix/devbox-rtk-nodejs-pnpm-prefer.nix { inherit pkgs; };
        devbox-rtk-nodejs-pnpm-block = import ./nix/devbox-rtk-nodejs-pnpm-block.nix { inherit pkgs; };
        devbox-rtk-nodejs-pnpm-native = import ./nix/devbox-rtk-nodejs-pnpm-native.nix { inherit pkgs; };
        devbox-rtk-nodejs-yarn-force = import ./nix/devbox-rtk-nodejs-yarn-force.nix { inherit pkgs; };
        devbox-rtk-nodejs-yarn-prefer = import ./nix/devbox-rtk-nodejs-yarn-prefer.nix { inherit pkgs; };
        devbox-rtk-nodejs-yarn-block = import ./nix/devbox-rtk-nodejs-yarn-block.nix { inherit pkgs; };
        devbox-rtk-nodejs-yarn-native = import ./nix/devbox-rtk-nodejs-yarn-native.nix { inherit pkgs; };
        devbox-rtk-nodejs-bun-force = import ./nix/devbox-rtk-nodejs-bun-force.nix { inherit pkgs; };
        devbox-rtk-nodejs-bun-prefer = import ./nix/devbox-rtk-nodejs-bun-prefer.nix { inherit pkgs; };
        devbox-rtk-nodejs-bun-block = import ./nix/devbox-rtk-nodejs-bun-block.nix { inherit pkgs; };
        devbox-rtk-nodejs-bun-native = import ./nix/devbox-rtk-nodejs-bun-native.nix { inherit pkgs; };
        devbox-rtk-python-uv-force = import ./nix/devbox-rtk-python-uv-force.nix { inherit pkgs; };
        devbox-rtk-python-uv-prefer = import ./nix/devbox-rtk-python-uv-prefer.nix { inherit pkgs; };
        devbox-rtk-python-uv-block = import ./nix/devbox-rtk-python-uv-block.nix { inherit pkgs; };
        devbox-rtk-python-uv-native = import ./nix/devbox-rtk-python-uv-native.nix { inherit pkgs; };
        
        # nub governance packages (depend on github:nubjs/nub)
        prefer-nub = import ./nix/prefer-nub.nix { inherit pkgs; };
        force-nub = import ./nix/force-nub.nix { inherit pkgs nub-pkg; };
        block-nub = import ./nix/block-nub.nix { inherit pkgs; };
        eject-nub = import ./nix/eject-nub.nix { inherit pkgs; };
        prefer-nub-from-pnpm = import ./nix/prefer-nub-from-pnpm.nix { inherit pkgs; };
        force-nub-from-pnpm = import ./nix/force-nub-from-pnpm.nix { inherit pkgs nub-pkg; };
        block-nub-from-pnpm = import ./nix/block-nub-from-pnpm.nix { inherit pkgs; };
        eject-nub-from-pnpm = import ./nix/eject-nub-from-pnpm.nix { inherit pkgs; };
        prefer-nub-from-yarn = import ./nix/prefer-nub-from-yarn.nix { inherit pkgs; };
        force-nub-from-yarn = import ./nix/force-nub-from-yarn.nix { inherit pkgs nub-pkg; };
        block-nub-from-yarn = import ./nix/block-nub-from-yarn.nix { inherit pkgs; };
        eject-nub-from-yarn = import ./nix/eject-nub-from-yarn.nix { inherit pkgs; };
        prefer-nub-from-bun = import ./nix/prefer-nub-from-bun.nix { inherit pkgs; };
        force-nub-from-bun = import ./nix/force-nub-from-bun.nix { inherit pkgs nub-pkg; };
        block-nub-from-bun = import ./nix/block-nub-from-bun.nix { inherit pkgs; };
        eject-nub-from-bun = import ./nix/eject-nub-from-bun.nix { inherit pkgs; };

        # Bundle package
        command-governance = import ./nix/bundle-command-governance.nix { inherit pkgs; };

      in
      {
        packages = {
          # npm governance packages
          inherit prefer-pnpm;
          inherit eject-npm;
          inherit force-pnpm;
          inherit block-npm;
          inherit prefer-yarn;
          inherit eject-yarn;
          inherit force-yarn;
          inherit block-yarn;
          inherit prefer-bun;
          inherit eject-bun;
          inherit force-bun;
          inherit block-bun;
          # pnpm governance packages
          inherit prefer-uv;
          inherit eject-pip;
          inherit block-pip;
          inherit prefer-npm;
          inherit force-npm;
          inherit eject-pnpm;
          inherit block-pnpm;
          inherit prefer-yarn-from-pnpm;
          inherit force-yarn-from-pnpm;
          inherit block-yarn-from-pnpm;
          inherit eject-yarn-from-pnpm;
          inherit prefer-bun-from-pnpm;
          inherit force-bun-from-pnpm;
          inherit block-bun-from-pnpm;
          inherit eject-bun-from-pnpm;
          # yarn governance packages
          inherit prefer-npm-from-yarn;
          inherit force-npm-from-yarn;
          inherit block-npm-from-yarn;
          inherit eject-npm-from-yarn;
          inherit prefer-pnpm-from-yarn;
          inherit force-pnpm-from-yarn;
          inherit block-pnpm-from-yarn;
          inherit eject-pnpm-from-yarn;
          inherit prefer-bun-from-yarn;
          inherit force-bun-from-yarn;
          inherit block-bun-from-yarn;
          inherit eject-bun-from-yarn;
          # bun governance packages
          inherit prefer-npm-from-bun;
          inherit force-npm-from-bun;
          inherit block-npm-from-bun;
          inherit eject-npm-from-bun;
          inherit prefer-pnpm-from-bun;
          inherit force-pnpm-from-bun;
          inherit block-pnpm-from-bun;
          inherit eject-pnpm-from-bun;
          inherit prefer-yarn-from-bun;
          inherit force-yarn-from-bun;
          inherit block-yarn-from-bun;
          inherit eject-yarn-from-bun;
          # nub governance packages (depend on github:nubjs/nub)
          inherit prefer-nub;
          inherit force-nub;
          inherit block-nub;
          inherit eject-nub;
          inherit prefer-nub-from-pnpm;
          inherit force-nub-from-pnpm;
          inherit block-nub-from-pnpm;
          inherit eject-nub-from-pnpm;
          inherit prefer-nub-from-yarn;
          inherit force-nub-from-yarn;
          inherit block-nub-from-yarn;
          inherit eject-nub-from-yarn;
          inherit prefer-nub-from-bun;
          inherit force-nub-from-bun;
          inherit block-nub-from-bun;
          inherit eject-nub-from-bun;
          # Other packages
          inherit prefer-devbox;
          inherit prefer-corepack;
          # Search tool governance packages
          inherit prefer-grep;
          inherit eject-grep;
          inherit force-grep;
          inherit block-grep;
          inherit prefer-ag;
          inherit eject-ag;
          inherit force-ag;
          inherit block-ag;
          inherit prefer-git-grep;
          inherit eject-git-grep;
          inherit force-git-grep;
          inherit block-git-grep;
          inherit prefer-ucg;
          inherit eject-ucg;
          inherit force-ucg;
          inherit block-ucg;
          inherit prefer-pt;
          inherit eject-pt;
          inherit force-pt;
          inherit block-pt;
          inherit prefer-sift;
          inherit eject-sift;
          inherit force-sift;
          inherit block-sift;

          # Devbox reminder governance packages
          inherit prefer-cargo;
          inherit force-cargo;
          inherit block-cargo;
          inherit eject-cargo;
          inherit prefer-rustc;
          inherit force-rustc;
          inherit block-rustc;
          inherit eject-rustc;
          inherit prefer-tsc;
          inherit force-tsc;
          inherit block-tsc;
          inherit eject-tsc;
          inherit prefer-node;
          inherit force-node;
          inherit block-node;
          inherit eject-node;
          inherit prefer-python3;
          inherit force-python3;
          inherit block-python3;
          inherit eject-python3;
          inherit prefer-python;
          inherit force-python;
          inherit block-python;
          inherit eject-python;
          inherit prefer-pip;
          inherit force-pip;
          inherit prefer-pip3;
          inherit force-pip3;
          inherit block-pip3;
          inherit eject-pip3;
          inherit force-uv;
          inherit block-uv;
          inherit eject-uv;
          inherit prefer-java;
          inherit force-java;
          inherit block-java;
          inherit eject-java;
          inherit prefer-javac;
          inherit force-javac;
          inherit block-javac;
          inherit eject-javac;
          inherit prefer-go;
          inherit force-go;
          inherit block-go;
          inherit eject-go;
          inherit prefer-swift;
          inherit force-swift;
          inherit block-swift;
          inherit eject-swift;
          inherit prefer-make;
          inherit force-make;
          inherit block-make;
          inherit eject-make;
          inherit prefer-cmake;
          inherit force-cmake;
          inherit block-cmake;
          inherit eject-cmake;
          inherit prefer-ninja;
          inherit force-ninja;
          inherit block-ninja;
          inherit eject-ninja;
          inherit prefer-just;
          inherit force-just;
          inherit block-just;
          inherit eject-just;
          inherit prefer-gcc;
          inherit force-gcc;
          inherit block-gcc;
          inherit eject-gcc;
          inherit prefer-gpp;
          inherit force-gpp;
          inherit block-gpp;
          inherit eject-gpp;
          inherit prefer-clang;
          inherit force-clang;
          inherit block-clang;
          inherit eject-clang;
          inherit prefer-dotnet;
          inherit force-dotnet;
          inherit block-dotnet;
          inherit eject-dotnet;
          inherit prefer-ruby;
          inherit force-ruby;
          inherit block-ruby;
          inherit eject-ruby;
          inherit prefer-gem;
          inherit force-gem;
          inherit block-gem;
          inherit eject-gem;
          
          # RTK wrapper packages
          inherit rtk-wrap-ls;
          inherit rtk-wrap-tree;
          inherit rtk-wrap-git;
          inherit rtk-wrap-grep;
          inherit rtk-wrap-find;
          inherit rtk-wrap-cat;
          inherit rtk-wrap-npm;
          inherit rtk-wrap-npx;
          inherit rtk-wrap-tsc;
          inherit rtk-wrap-jest;
          inherit rtk-wrap-vitest;
          inherit rtk-wrap-pytest;
          inherit rtk-wrap-mypy;
          inherit rtk-wrap-ruff;
          inherit rtk-wrap-prettier;
          inherit rtk-wrap-eslint;
          inherit rtk-wrap-gh;
          inherit rtk-wrap-diff;
          inherit rtk-wrap-curl;
          inherit rtk-wrap-wc;
          inherit rtk-wrap-docker;
          inherit rtk-wrap-kubectl;
          inherit rtk-wrap-cargo;
          inherit rtk-wrap-pip;
          inherit rtk-wrap-dotnet;
          inherit rtk-wrap-aws;
          inherit rtk-wrap-psql;
          inherit rtk-wrap-json;
          inherit rtk-wrap-env;
          inherit rtk-wrap-deps;
          inherit rtk-wrap-test;
          inherit rtk-wrap-err;
          inherit rtk-wrap-pnpm;
          inherit rtk-wrap-prisma;
          inherit rtk-wrap-next;
          inherit rtk-wrap-lint;
          inherit rtk-wrap-format;
          inherit rtk-wrap-playwright;
          inherit rtk-wrap-glab;
          inherit rtk-wrap-wget;
          inherit rtk-wrap-go;
          inherit rtk-wrap-gt;
          inherit rtk-wrap-golangci-lint;
          inherit rtk-wrap-rubocop;
          inherit rtk-wrap-rake;
          inherit rtk-wrap-rspec;
          inherit rtk-wrap-oc;
          inherit rtk-wrap-gradlew;
          
          # RTK bundle packages
          inherit bundle-rtk-core;
          inherit bundle-rtk-development;
          inherit bundle-rtk-cloud;
          inherit bundle-rtk-all;
          
          # Devbox auto-wrapper packages
          inherit devbox-auto-npm;
          inherit devbox-auto-pnpm;
          inherit devbox-auto-yarn;
          inherit devbox-auto-python;
          inherit devbox-auto-pip;
          inherit devbox-auto-cargo;
          inherit devbox-auto-rustc;
          inherit devbox-auto-go;
          
          # Devbox auto bundle packages
          inherit bundle-devbox-auto-nodejs;
          inherit bundle-devbox-auto-python;
          inherit bundle-devbox-auto-rust;
          inherit bundle-devbox-auto-go;
          inherit bundle-devbox-auto-all;
          
          # Integrated devbox-rtk-governance packages
          inherit devbox-rtk-nodejs-pnpm-force;
          inherit devbox-rtk-nodejs-pnpm-prefer;
          inherit devbox-rtk-nodejs-pnpm-block;
          inherit devbox-rtk-nodejs-pnpm-native;
          inherit devbox-rtk-nodejs-yarn-force;
          inherit devbox-rtk-nodejs-yarn-prefer;
          inherit devbox-rtk-nodejs-yarn-block;
          inherit devbox-rtk-nodejs-yarn-native;
          inherit devbox-rtk-nodejs-bun-force;
          inherit devbox-rtk-nodejs-bun-prefer;
          inherit devbox-rtk-nodejs-bun-block;
          inherit devbox-rtk-nodejs-bun-native;
          inherit devbox-rtk-python-uv-force;
          inherit devbox-rtk-python-uv-prefer;
          inherit devbox-rtk-python-uv-block;
          inherit devbox-rtk-python-uv-native;
          
          nodejs-ecosystem = import ./nix/nodejs-ecosystem.nix { inherit pkgs; };
          python-ecosystem = import ./nix/python-ecosystem.nix { inherit pkgs; };
          dev-tools = import ./nix/dev-tools.nix { inherit pkgs; };
          migrate-to-pnpm-bundle = import ./nix/migrate-to-pnpm-bundle.nix { inherit pkgs; };
          migrate-to-uv-bundle = import ./nix/migrate-to-uv-bundle.nix { inherit pkgs; };
          inherit command-governance;
          
          # Default package
          default = command-governance;
        };
        
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            just
            nix
            devbox
          ];
        };
      });
}
