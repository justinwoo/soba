{ pkgs ? import ./pinned.nix {} }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

  easy-ps = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "14e7d85431e9f9838d7107d18cb79c7fa534f54e";
      sha256 = "0lmkppidmhnayv0919990ifdd61f9d23dzjzr8amz7hjgc74yxs0";
    }
  ) {
    inherit pkgs;
  };

  easy-dhall = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-dhall-nix";
      rev = "735ad924fd829c9bbee0a167e0b2bbbf91e2cad5";
      sha256 = "1r3sqs1cz0mcfwfvaq1d21vnppg5sqzqdl6w9krsw5ad5czkk190";
    }
  ) {
    inherit pkgs;
  };


in
pkgs.stdenv.mkDerivation rec {
  name = "soba";

  src = pkgs.fetchurl {
    url = "https://github.com/justinwoo/soba/releases/download/2020-02-01/soba";
    sha256 = "0sjyiy9ywjwlamf1ap9x49pglxxcm3lbjlg36y29fyiy5ybi2ady";
  };

  buildInputs = [ pkgs.makeWrapper ];

  dontStrip = true;

  libPath = pkgs.lib.makeLibraryPath [ pkgs.glibc ];

  bins = [
    easy-ps.purs
    easy-ps.psc-package
    easy-dhall.dhall-simple
    easy-dhall.dhall-json-simple
    pkgs.nix-prefetch-git
  ];

  unpackPhase = ''
    mkdir -p $out/bin
    TARGET=$out/bin/soba

    cp $src $TARGET
    chmod +x $TARGET

    patchelf $TARGET \
      --interpreter ${dynamic-linker} \
      --set-rpath ${libPath}

    wrapProgram $TARGET \
      --prefix PATH : ${pkgs.lib.makeBinPath bins}
  '';

  dontInstall = true;
}
