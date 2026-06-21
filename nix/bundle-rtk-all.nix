{ pkgs }:

let
  # Import all RTK wrapper packages
  rtk-wrap-ls = import ./rtk-wrap-ls.nix { inherit pkgs; };
  rtk-wrap-tree = import ./rtk-wrap-tree.nix { inherit pkgs; };
  rtk-wrap-git = import ./rtk-wrap-git.nix { inherit pkgs; };
  rtk-wrap-grep = import ./rtk-wrap-grep.nix { inherit pkgs; };
  rtk-wrap-find = import ./rtk-wrap-find.nix { inherit pkgs; };
  rtk-wrap-cat = import ./rtk-wrap-cat.nix { inherit pkgs; };
  rtk-wrap-npm = import ./rtk-wrap-npm.nix { inherit pkgs; };
  rtk-wrap-npx = import ./rtk-wrap-npx.nix { inherit pkgs; };
  rtk-wrap-tsc = import ./rtk-wrap-tsc.nix { inherit pkgs; };
  rtk-wrap-jest = import ./rtk-wrap-jest.nix { inherit pkgs; };
  rtk-wrap-vitest = import ./rtk-wrap-vitest.nix { inherit pkgs; };
  rtk-wrap-pytest = import ./rtk-wrap-pytest.nix { inherit pkgs; };
  rtk-wrap-mypy = import ./rtk-wrap-mypy.nix { inherit pkgs; };
  rtk-wrap-ruff = import ./rtk-wrap-ruff.nix { inherit pkgs; };
  rtk-wrap-prettier = import ./rtk-wrap-prettier.nix { inherit pkgs; };
  rtk-wrap-eslint = import ./rtk-wrap-eslint.nix { inherit pkgs; };
  rtk-wrap-prisma = import ./rtk-wrap-prisma.nix { inherit pkgs; };
  rtk-wrap-next = import ./rtk-wrap-next.nix { inherit pkgs; };
  rtk-wrap-lint = import ./rtk-wrap-lint.nix { inherit pkgs; };
  rtk-wrap-format = import ./rtk-wrap-format.nix { inherit pkgs; };
  rtk-wrap-playwright = import ./rtk-wrap-playwright.nix { inherit pkgs; };
  rtk-wrap-pnpm = import ./rtk-wrap-pnpm.nix { inherit pkgs; };
  rtk-wrap-glab = import ./rtk-wrap-glab.nix { inherit pkgs; };
  rtk-wrap-wget = import ./rtk-wrap-wget.nix { inherit pkgs; };
  rtk-wrap-go = import ./rtk-wrap-go.nix { inherit pkgs; };
  rtk-wrap-gt = import ./rtk-wrap-gt.nix { inherit pkgs; };
  rtk-wrap-golangci-lint = import ./rtk-wrap-golangci-lint.nix { inherit pkgs; };
  rtk-wrap-rubocop = import ./rtk-wrap-rubocop.nix { inherit pkgs; };
  rtk-wrap-rake = import ./rtk-wrap-rake.nix { inherit pkgs; };
  rtk-wrap-rspec = import ./rtk-wrap-rspec.nix { inherit pkgs; };
  rtk-wrap-oc = import ./rtk-wrap-oc.nix { inherit pkgs; };
  rtk-wrap-gradlew = import ./rtk-wrap-gradlew.nix { inherit pkgs; };
  rtk-wrap-gh = import ./rtk-wrap-gh.nix { inherit pkgs; };
  rtk-wrap-diff = import ./rtk-wrap-diff.nix { inherit pkgs; };
  rtk-wrap-curl = import ./rtk-wrap-curl.nix { inherit pkgs; };
  rtk-wrap-wc = import ./rtk-wrap-wc.nix { inherit pkgs; };
  rtk-wrap-docker = import ./rtk-wrap-docker.nix { inherit pkgs; };
  rtk-wrap-kubectl = import ./rtk-wrap-kubectl.nix { inherit pkgs; };
  rtk-wrap-cargo = import ./rtk-wrap-cargo.nix { inherit pkgs; };
  rtk-wrap-pip = import ./rtk-wrap-pip.nix { inherit pkgs; };
  rtk-wrap-dotnet = import ./rtk-wrap-dotnet.nix { inherit pkgs; };
  rtk-wrap-aws = import ./rtk-wrap-aws.nix { inherit pkgs; };
  rtk-wrap-psql = import ./rtk-wrap-psql.nix { inherit pkgs; };
  rtk-wrap-json = import ./rtk-wrap-json.nix { inherit pkgs; };
  rtk-wrap-env = import ./rtk-wrap-env.nix { inherit pkgs; };
  rtk-wrap-deps = import ./rtk-wrap-deps.nix { inherit pkgs; };
  rtk-wrap-test = import ./rtk-wrap-test.nix { inherit pkgs; };
  rtk-wrap-err = import ./rtk-wrap-err.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "bundle-rtk-all";
  paths = [
    rtk-wrap-ls
    rtk-wrap-tree
    rtk-wrap-git
    rtk-wrap-grep
    rtk-wrap-find
    rtk-wrap-cat
    rtk-wrap-npm
    rtk-wrap-npx
    rtk-wrap-tsc
    rtk-wrap-jest
    rtk-wrap-vitest
    rtk-wrap-pytest
    rtk-wrap-mypy
    rtk-wrap-ruff
    rtk-wrap-prettier
    rtk-wrap-eslint
    rtk-wrap-prisma
    rtk-wrap-next
    rtk-wrap-lint
    rtk-wrap-format
    rtk-wrap-playwright
    rtk-wrap-pnpm
    rtk-wrap-glab
    rtk-wrap-wget
    rtk-wrap-go
    rtk-wrap-gt
    rtk-wrap-golangci-lint
    rtk-wrap-rubocop
    rtk-wrap-rake
    rtk-wrap-rspec
    rtk-wrap-oc
    rtk-wrap-gradlew
    rtk-wrap-gh
    rtk-wrap-diff
    rtk-wrap-curl
    rtk-wrap-wc
    rtk-wrap-docker
    rtk-wrap-kubectl
    rtk-wrap-cargo
    rtk-wrap-pip
    rtk-wrap-dotnet
    rtk-wrap-aws
    rtk-wrap-psql
    rtk-wrap-json
    rtk-wrap-env
    rtk-wrap-deps
    rtk-wrap-test
    rtk-wrap-err
  ];
}