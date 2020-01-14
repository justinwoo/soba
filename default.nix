{ pkgs ? import ./pinned.nix {} }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

  easy-ps = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "cd549a1fb33252f3fb2d807d4c8ea4a19903230f";
      sha256 = "1vl0h5k0bcn2v6b10sj2jjyvnzvq16qfq527g1xi3gzjx7ylfs0g";
    }
  ) {
    inherit pkgs;
  };

  easy-dhall = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-dhall-nix";
      rev = "1aa3b306e49cada554d8acfe3902e27527ecef98";
      sha256 = "1hhm4m6y5iavfx088qbifn76jdrgglkgqvmgki8z6hj5bz5mnh06";
    }
  ) {
    inherit pkgs;
  };


in
pkgs.stdenv.mkDerivation rec {
  name = "soba";

  src = pkgs.fetchurl {
    url = "https://github.com/justinwoo/soba/releases/download/2020-01-14/soba";
    sha256 = "1hh2b97d6pp6kshbygy1jcsxixg63d2c780hvamwkv81lfnaydiq";
  };

  buildInputs = [ pkgs.makeWrapper ];

  dontStrip = true;

  libPath = pkgs.lib.makeLibraryPath [ pkgs.glibc ];

  unpackPhase = ''
    mkdir -p $out/bin
    TARGET=$out/bin/soba

    cp $src $TARGET
    chmod +x $TARGET

    patchelf $TARGET \
      --interpreter ${dynamic-linker} \
      --set-rpath ${libPath}

    wrapProgram $TARGET \
      --prefix PATH : ${pkgs.lib.makeBinPath [
        easy-ps.purs
        easy-ps.psc-package
        easy-dhall.dhall-simple
        easy-dhall.dhall-json-simple
      ]}
  '';

  dontInstall = true;
}
