{ pkgs ? import ./pinned.nix {} }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

  easy-ps = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "d5f44b9389b290874cc3e479741b746067f19a78";
      sha256 = "0vswaasg2ik7csi40a0ihpxxzp4c803z7mjd096f3lmjrbw4j4av";
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
