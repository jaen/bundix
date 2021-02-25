{
  description = "Fresha development environment";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs      = { url = "github:jaen/nixpkgs?ref=fix-ruby-bundler-groups&shallow"; };
    flake-utils  = { url = "github:numtide/flake-utils";   inputs.nixpkgs.follows = "nixpkgs"; };
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
  };

  outputs = args: import ./nix/outputs.nix args;
}
