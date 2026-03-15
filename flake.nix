{
  description = "Command Preference & Package Governance System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Import all packages
        prefer-pnpm = import ./nix/prefer-pnpm.nix { inherit pkgs; };
        eject-npm = import ./nix/eject-npm.nix { inherit pkgs; };
        force-pnpm = import ./nix/force-pnpm.nix { inherit pkgs; };
        block-npm = import ./nix/block-npm.nix { inherit pkgs; };
        prefer-uv = import ./nix/prefer-uv.nix { inherit pkgs; };
        eject-pip = import ./nix/eject-pip.nix { inherit pkgs; };
        block-pip = import ./nix/block-pip.nix { inherit pkgs; };
        prefer-devbox = import ./nix/prefer-devbox.nix { inherit pkgs; };
        prefer-corepack = import ./nix/prefer-corepack.nix { inherit pkgs; };
        
        # Bundle package
        command-governance = import ./nix/bundle-command-governance.nix { inherit pkgs; };
        
      in
      {
        packages = {
          # Individual packages
          inherit prefer-pnpm;
          inherit eject-npm;
          inherit force-pnpm;
          inherit block-npm;
          inherit prefer-uv;
          inherit eject-pip;
          inherit block-pip;
          inherit prefer-devbox;
          inherit prefer-corepack;
          
          # Bundle package
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
