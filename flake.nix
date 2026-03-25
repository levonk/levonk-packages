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
