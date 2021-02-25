inputs@{
  self,
  nixpkgs,
  flake-utils,
  flake-compat,
  ...
}:
  flake-utils.lib.eachSystem [ "x86_64-linux" ]
    (system:
      let
        pkgImport = pkgs:
          import pkgs {
            inherit system;
            overlays = [
               (final: prev: { nix = prev.nixUnstable; })
            ];
          };

        pkgs = pkgImport nixpkgs;
        lib  = pkgs.lib;
        bundix = pkgs.callPackage ./packages/bundix.nix {};
        gems = pkgs.bundlerEnv {
          ruby = pkgs.ruby;
          name = "bundix-gems";
          gemfile  = ./../Gemfile;
          lockfile = ./../Gemfile.lock;
          gemset   = ./gemset.nix;
        };
      in
        {
          defaultPackage = bundix;
          packages = {
            inherit bundix;
          };
          devShell = pkgs.mkShell {
            TERM = "xterm";

            buildInputs = with pkgs; [
              gems.wrappedRuby
              gems
              # zlib
              ruby
              nix-prefetch-scripts
              bundix
            ];
          };
        })
