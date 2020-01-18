{ pkgs ? import ./pinned.nix {} }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

  easy-ps = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "485471b86f764b9dd34e77ae767a629290f7f295";
      sha256 = "0fh7sxpnp8krs091imksrs6w3vw31sq9kpz26mdw1kbpa8f0sgby";
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
    url = "https://github.com/justinwoo/soba/releases/download/2020-01-18/soba";
    sha256 = "1lxbz6q6g7ak3yf7p182pz2qkmg80154my1hl685773r6gyb7mms";
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
