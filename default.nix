{ pkgs ? import ./pinned.nix {} }:

let
  dynamic-linker = pkgs.stdenv.cc.bintools.dynamicLinker;

  easy-ps = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "17d40cef56527d3d337f136d2dbc5514f7742470";
      sha256 = "0smi1rzdgiwjbrbcnfmq4an0snimxsr9x2kwkic4irwnm9c8wa1d";
    }
  ) {
    inherit pkgs;
  };

  easy-dhall = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-dhall-nix";
      rev = "29769888e2918470d5a4c65ef5ea331af635bc07";
      sha256 = "16xk5w3xfb38p57sdlmm3mdbnrji2j69zwkzzc4jnhj0srkawzsd";
    }
  ) {
    inherit pkgs;
  };


in
pkgs.stdenv.mkDerivation rec {
  name = "soba";

  src = pkgs.fetchurl {
    url = "https://github.com/justinwoo/soba/releases/download/2020-02-01/soba";
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
