{ pkgs }:

let
  # Import all RTK wrapper packages
  rtk-wrap-ls = import ./rtk-wrap-ls.nix { inherit pkgs; };
  rtk-wrap-tree = import ./rtk-wrap-tree.nix { inherit pkgs; };
  rtk-wrap-git = import ./rtk-wrap-git.nix { inherit pkgs; };
  rtk-wrap-grep = import ./rtk-wrap-grep.nix { inherit pkgs; };
  rtk-wrap-find = import ./rtk-wrap-find.nix { inherit pkgs; };
  rtk-wrap-cat = import ./rtk-wrap-cat.nix { inherit pkgs; };
  rtk-wrap-diff = import ./rtk-wrap-diff.nix { inherit pkgs; };
  rtk-wrap-wc = import ./rtk-wrap-wc.nix { inherit pkgs; };
  rtk-wrap-curl = import ./rtk-wrap-curl.nix { inherit pkgs; };
  rtk-wrap-json = import ./rtk-wrap-json.nix { inherit pkgs; };
  rtk-wrap-env = import ./rtk-wrap-env.nix { inherit pkgs; };
  rtk-wrap-deps = import ./rtk-wrap-deps.nix { inherit pkgs; };
  rtk-wrap-test = import ./rtk-wrap-test.nix { inherit pkgs; };
  rtk-wrap-err = import ./rtk-wrap-err.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "bundle-rtk-core";
  paths = [
    rtk-wrap-ls
    rtk-wrap-tree
    rtk-wrap-git
    rtk-wrap-grep
    rtk-wrap-find
    rtk-wrap-cat
    rtk-wrap-diff
    rtk-wrap-wc
    rtk-wrap-curl
    rtk-wrap-json
    rtk-wrap-env
    rtk-wrap-deps
    rtk-wrap-test
    rtk-wrap-err
  ];
}