{
  pkgs ? (import <nixpkgs> {}),
  ruby ? pkgs.ruby_2_6,
  bundler ? (pkgs.bundler.override { inherit ruby; }),
  nix ? pkgs.nix,
  nix-prefetch-git ? pkgs.nix-prefetch-git,
}:
pkgs.stdenv.mkDerivation rec {
  version = "2.5.0";
  name = "bundix";
  src = ./.;
  phases = "installPhase";
  installPhase = ''
    cp -r $src $out
    chmod -R u+rw $out/bin
    wrapProgram $out/bin/bundix \
      --prefix PATH : "${nix}/bin" \
      --prefix PATH : "${nix-prefetch-scripts}/bin" \
      --prefix PATH : "${nix-prefetch-git}/bin" \
      --prefix PATH : "${app}/bin" \
      --set GEM_PATH "${app}/${app.ruby.gemPath}/gems"
  '';

  postFixup = ''
    $out/bin/bundix -v
  '';

  meta = with pkgs.lib; {
    inherit version;
    description = "Creates Nix packages from Gemfiles";
    longDescription = ''
      This is a tool that converts Gemfile.lock files to nix expressions.

      The output is then usable by the bundlerEnv derivation to list all the
      dependencies of a ruby package.
    '';
    homepage = "https://github.com/manveru/bundix";
    license = "MIT";
    maintainers = with maintainers; [ manveru zimbatm ];
    platforms = platforms.all;
  };
}
