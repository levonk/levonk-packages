{ pkgs }:

let
  # Import RTK cloud tool wrappers
  rtk-wrap-gh = import ./rtk-wrap-gh.nix { inherit pkgs; };
  rtk-wrap-glab = import ./rtk-wrap-glab.nix { inherit pkgs; };
  rtk-wrap-curl = import ./rtk-wrap-curl.nix { inherit pkgs; };
  rtk-wrap-wget = import ./rtk-wrap-wget.nix { inherit pkgs; };
  rtk-wrap-aws = import ./rtk-wrap-aws.nix { inherit pkgs; };
  rtk-wrap-docker = import ./rtk-wrap-docker.nix { inherit pkgs; };
  rtk-wrap-kubectl = import ./rtk-wrap-kubectl.nix { inherit pkgs; };
  rtk-wrap-oc = import ./rtk-wrap-oc.nix { inherit pkgs; };
  rtk-wrap-gt = import ./rtk-wrap-gt.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "bundle-rtk-cloud";
  paths = [
    rtk-wrap-gh
    rtk-wrap-glab
    rtk-wrap-curl
    rtk-wrap-wget
    rtk-wrap-aws
    rtk-wrap-docker
    rtk-wrap-kubectl
    rtk-wrap-oc
    rtk-wrap-gt
  ];
}