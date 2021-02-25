{
  description = "Fresha development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils  = { url = "github:numtide/flake-utils";   inputs.nixpkgs.follows = "nixpkgs"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = args: import ./nix/outputs.nix args;
}
