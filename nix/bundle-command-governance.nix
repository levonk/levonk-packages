{ pkgs }:

let
  # Import all individual packages
  prefer-pnpm = import ./prefer-pnpm.nix { inherit pkgs; };
  eject-npm = import ./eject-npm.nix { inherit pkgs; };
  force-pnpm = import ./force-pnpm.nix { inherit pkgs; };
  block-npm = import ./block-npm.nix { inherit pkgs; };
  prefer-yarn = import ./prefer-yarn.nix { inherit pkgs; };
  eject-yarn = import ./eject-yarn.nix { inherit pkgs; };
  force-yarn = import ./force-yarn.nix { inherit pkgs; };
  block-yarn = import ./block-yarn.nix { inherit pkgs; };
  prefer-bun = import ./prefer-bun.nix { inherit pkgs; };
  eject-bun = import ./eject-bun.nix { inherit pkgs; };
  force-bun = import ./force-bun.nix { inherit pkgs; };
  block-bun = import ./block-bun.nix { inherit pkgs; };
  
  prefer-uv = import ./prefer-uv.nix { inherit pkgs; };
  eject-pip = import ./eject-pip.nix { inherit pkgs; };
  block-pip = import ./block-pip.nix { inherit pkgs; };
  
  prefer-npm = import ./prefer-npm.nix { inherit pkgs; };
  force-npm = import ./force-npm.nix { inherit pkgs; };
  eject-pnpm = import ./eject-pnpm.nix { inherit pkgs; };
  block-pnpm = import ./block-pnpm.nix { inherit pkgs; };
  
  prefer-yarn-from-pnpm = import ./prefer-yarn-from-pnpm.nix { inherit pkgs; };
  force-yarn-from-pnpm = import ./force-yarn-from-pnpm.nix { inherit pkgs; };
  block-yarn-from-pnpm = import ./block-yarn-from-pnpm.nix { inherit pkgs; };
  eject-yarn-from-pnpm = import ./eject-yarn-from-pnpm.nix { inherit pkgs; };
  
  prefer-bun-from-pnpm = import ./prefer-bun-from-pnpm.nix { inherit pkgs; };
  force-bun-from-pnpm = import ./force-bun-from-pnpm.nix { inherit pkgs; };
  block-bun-from-pnpm = import ./block-bun-from-pnpm.nix { inherit pkgs; };
  eject-bun-from-pnpm = import ./eject-bun-from-pnpm.nix { inherit pkgs; };
  
  prefer-npm-from-yarn = import ./prefer-npm-from-yarn.nix { inherit pkgs; };
  force-npm-from-yarn = import ./force-npm-from-yarn.nix { inherit pkgs; };
  block-npm-from-yarn = import ./block-npm-from-yarn.nix { inherit pkgs; };
  eject-npm-from-yarn = import ./eject-npm-from-yarn.nix { inherit pkgs; };
  
  prefer-pnpm-from-yarn = import ./prefer-pnpm-from-yarn.nix { inherit pkgs; };
  force-pnpm-from-yarn = import ./force-pnpm-from-yarn.nix { inherit pkgs; };
  block-pnpm-from-yarn = import ./block-pnpm-from-yarn.nix { inherit pkgs; };
  eject-pnpm-from-yarn = import ./eject-pnpm-from-yarn.nix { inherit pkgs; };
  
  prefer-bun-from-yarn = import ./prefer-bun-from-yarn.nix { inherit pkgs; };
  force-bun-from-yarn = import ./force-bun-from-yarn.nix { inherit pkgs; };
  block-bun-from-yarn = import ./block-bun-from-yarn.nix { inherit pkgs; };
  eject-bun-from-yarn = import ./eject-bun-from-yarn.nix { inherit pkgs; };
  
  prefer-npm-from-bun = import ./prefer-npm-from-bun.nix { inherit pkgs; };
  force-npm-from-bun = import ./force-npm-from-bun.nix { inherit pkgs; };
  block-npm-from-bun = import ./block-npm-from-bun.nix { inherit pkgs; };
  eject-npm-from-bun = import ./eject-npm-from-bun.nix { inherit pkgs; };
  
  prefer-pnpm-from-bun = import ./prefer-pnpm-from-bun.nix { inherit pkgs; };
  force-pnpm-from-bun = import ./force-pnpm-from-bun.nix { inherit pkgs; };
  block-pnpm-from-bun = import ./block-pnpm-from-bun.nix { inherit pkgs; };
  eject-pnpm-from-bun = import ./eject-pnpm-from-bun.nix { inherit pkgs; };
  
  prefer-yarn-from-bun = import ./prefer-yarn-from-bun.nix { inherit pkgs; };
  force-yarn-from-bun = import ./force-yarn-from-bun.nix { inherit pkgs; };
  block-yarn-from-bun = import ./block-yarn-from-bun.nix { inherit pkgs; };
  eject-yarn-from-bun = import ./eject-yarn-from-bun.nix { inherit pkgs; };
  
  prefer-devbox = import ./prefer-devbox.nix { inherit pkgs; };
  prefer-corepack = import ./prefer-corepack.nix { inherit pkgs; };
  

  prefer-cargo = import ./prefer-cargo.nix { inherit pkgs; };
  force-cargo = import ./force-cargo.nix { inherit pkgs; };
  block-cargo = import ./block-cargo.nix { inherit pkgs; };
  eject-cargo = import ./eject-cargo.nix { inherit pkgs; };
  prefer-rustc = import ./prefer-rustc.nix { inherit pkgs; };
  force-rustc = import ./force-rustc.nix { inherit pkgs; };
  block-rustc = import ./block-rustc.nix { inherit pkgs; };
  eject-rustc = import ./eject-rustc.nix { inherit pkgs; };
  prefer-tsc = import ./prefer-tsc.nix { inherit pkgs; };
  force-tsc = import ./force-tsc.nix { inherit pkgs; };
  block-tsc = import ./block-tsc.nix { inherit pkgs; };
  eject-tsc = import ./eject-tsc.nix { inherit pkgs; };
  prefer-node = import ./prefer-node.nix { inherit pkgs; };
  force-node = import ./force-node.nix { inherit pkgs; };
  block-node = import ./block-node.nix { inherit pkgs; };
  eject-node = import ./eject-node.nix { inherit pkgs; };
  prefer-python3 = import ./prefer-python3.nix { inherit pkgs; };
  force-python3 = import ./force-python3.nix { inherit pkgs; };
  block-python3 = import ./block-python3.nix { inherit pkgs; };
  eject-python3 = import ./eject-python3.nix { inherit pkgs; };
  prefer-python = import ./prefer-python.nix { inherit pkgs; };
  force-python = import ./force-python.nix { inherit pkgs; };
  block-python = import ./block-python.nix { inherit pkgs; };
  eject-python = import ./eject-python.nix { inherit pkgs; };
  prefer-pip = import ./prefer-pip.nix { inherit pkgs; };
  force-pip = import ./force-pip.nix { inherit pkgs; };
  block-pip = import ./block-pip.nix { inherit pkgs; };
  eject-pip = import ./eject-pip.nix { inherit pkgs; };
  prefer-pip3 = import ./prefer-pip3.nix { inherit pkgs; };
  force-pip3 = import ./force-pip3.nix { inherit pkgs; };
  block-pip3 = import ./block-pip3.nix { inherit pkgs; };
  eject-pip3 = import ./eject-pip3.nix { inherit pkgs; };
  prefer-uv = import ./prefer-uv.nix { inherit pkgs; };
  force-uv = import ./force-uv.nix { inherit pkgs; };
  block-uv = import ./block-uv.nix { inherit pkgs; };
  eject-uv = import ./eject-uv.nix { inherit pkgs; };
  prefer-java = import ./prefer-java.nix { inherit pkgs; };
  force-java = import ./force-java.nix { inherit pkgs; };
  block-java = import ./block-java.nix { inherit pkgs; };
  eject-java = import ./eject-java.nix { inherit pkgs; };
  prefer-javac = import ./prefer-javac.nix { inherit pkgs; };
  force-javac = import ./force-javac.nix { inherit pkgs; };
  block-javac = import ./block-javac.nix { inherit pkgs; };
  eject-javac = import ./eject-javac.nix { inherit pkgs; };
  prefer-go = import ./prefer-go.nix { inherit pkgs; };
  force-go = import ./force-go.nix { inherit pkgs; };
  block-go = import ./block-go.nix { inherit pkgs; };
  eject-go = import ./eject-go.nix { inherit pkgs; };
  prefer-swift = import ./prefer-swift.nix { inherit pkgs; };
  force-swift = import ./force-swift.nix { inherit pkgs; };
  block-swift = import ./block-swift.nix { inherit pkgs; };
  eject-swift = import ./eject-swift.nix { inherit pkgs; };
  prefer-make = import ./prefer-make.nix { inherit pkgs; };
  force-make = import ./force-make.nix { inherit pkgs; };
  block-make = import ./block-make.nix { inherit pkgs; };
  eject-make = import ./eject-make.nix { inherit pkgs; };
  prefer-cmake = import ./prefer-cmake.nix { inherit pkgs; };
  force-cmake = import ./force-cmake.nix { inherit pkgs; };
  block-cmake = import ./block-cmake.nix { inherit pkgs; };
  eject-cmake = import ./eject-cmake.nix { inherit pkgs; };
  prefer-ninja = import ./prefer-ninja.nix { inherit pkgs; };
  force-ninja = import ./force-ninja.nix { inherit pkgs; };
  block-ninja = import ./block-ninja.nix { inherit pkgs; };
  eject-ninja = import ./eject-ninja.nix { inherit pkgs; };
  prefer-just = import ./prefer-just.nix { inherit pkgs; };
  force-just = import ./force-just.nix { inherit pkgs; };
  block-just = import ./block-just.nix { inherit pkgs; };
  eject-just = import ./eject-just.nix { inherit pkgs; };
  prefer-gcc = import ./prefer-gcc.nix { inherit pkgs; };
  force-gcc = import ./force-gcc.nix { inherit pkgs; };
  block-gcc = import ./block-gcc.nix { inherit pkgs; };
  eject-gcc = import ./eject-gcc.nix { inherit pkgs; };
  prefer-clang = import ./prefer-clang.nix { inherit pkgs; };
  force-clang = import ./force-clang.nix { inherit pkgs; };
  block-clang = import ./block-clang.nix { inherit pkgs; };
  eject-clang = import ./eject-clang.nix { inherit pkgs; };
  prefer-dotnet = import ./prefer-dotnet.nix { inherit pkgs; };
  force-dotnet = import ./force-dotnet.nix { inherit pkgs; };
  block-dotnet = import ./block-dotnet.nix { inherit pkgs; };
  eject-dotnet = import ./eject-dotnet.nix { inherit pkgs; };
  prefer-ruby = import ./prefer-ruby.nix { inherit pkgs; };
  force-ruby = import ./force-ruby.nix { inherit pkgs; };
  block-ruby = import ./block-ruby.nix { inherit pkgs; };
  eject-ruby = import ./eject-ruby.nix { inherit pkgs; };
  prefer-gem = import ./prefer-gem.nix { inherit pkgs; };
  force-gem = import ./force-gem.nix { inherit pkgs; };
  block-gem = import ./block-gem.nix { inherit pkgs; };
  eject-gem = import ./eject-gem.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "command-governance";
  paths = [
    prefer-pnpm
    eject-npm
    force-pnpm
    block-npm
    prefer-yarn
    eject-yarn
    force-yarn
    block-yarn
    prefer-bun
    eject-bun
    force-bun
    block-bun
    prefer-uv
    eject-pip
    block-pip
    prefer-npm
    force-npm
    eject-pnpm
    block-pnpm
    prefer-yarn-from-pnpm
    force-yarn-from-pnpm
    block-yarn-from-pnpm
    eject-yarn-from-pnpm
    prefer-bun-from-pnpm
    force-bun-from-pnpm
    block-bun-from-pnpm
    eject-bun-from-pnpm
    prefer-npm-from-yarn
    force-npm-from-yarn
    block-npm-from-yarn
    eject-npm-from-yarn
    prefer-pnpm-from-yarn
    force-pnpm-from-yarn
    block-pnpm-from-yarn
    eject-pnpm-from-yarn
    prefer-bun-from-yarn
    force-bun-from-yarn
    block-bun-from-yarn
    eject-bun-from-yarn
    prefer-npm-from-bun
    force-npm-from-bun
    block-npm-from-bun
    eject-npm-from-bun
    prefer-pnpm-from-bun
    force-pnpm-from-bun
    block-pnpm-from-bun
    eject-pnpm-from-bun
    prefer-yarn-from-bun
    force-yarn-from-bun
    block-yarn-from-bun
    eject-yarn-from-bun

    prefer-cargo
    force-cargo
    block-cargo
    eject-cargo
    prefer-rustc
    force-rustc
    block-rustc
    eject-rustc
    prefer-tsc
    force-tsc
    block-tsc
    eject-tsc
    prefer-node
    force-node
    block-node
    eject-node
    prefer-python3
    force-python3
    block-python3
    eject-python3
    prefer-python
    force-python
    block-python
    eject-python
    prefer-pip
    force-pip
    block-pip
    eject-pip
    prefer-pip3
    force-pip3
    block-pip3
    eject-pip3
    prefer-uv
    force-uv
    block-uv
    eject-uv
    prefer-java
    force-java
    block-java
    eject-java
    prefer-javac
    force-javac
    block-javac
    eject-javac
    prefer-go
    force-go
    block-go
    eject-go
    prefer-swift
    force-swift
    block-swift
    eject-swift
    prefer-make
    force-make
    block-make
    eject-make
    prefer-cmake
    force-cmake
    block-cmake
    eject-cmake
    prefer-ninja
    force-ninja
    block-ninja
    eject-ninja
    prefer-just
    force-just
    block-just
    eject-just
    prefer-gcc
    force-gcc
    block-gcc
    eject-gcc
    prefer-clang
    force-clang
    block-clang
    eject-clang
    prefer-dotnet
    force-dotnet
    block-dotnet
    eject-dotnet
    prefer-ruby
    force-ruby
    block-ruby
    eject-ruby
    prefer-gem
    force-gem
    block-gem
    eject-gem
    prefer-devbox
    prefer-corepack
  ];
}
