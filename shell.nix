{ pkgs ? import ./pinned.nix {} }:

let

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

  includePaths = pkgs.lib.makeLibraryPath [
    pkgs.glibc
  ];

in
pkgs.mkShell {
  buildInputs = [
    easy-ps.purs
    easy-ps.psc-package
    easy-dhall.dhall-simple
    easy-dhall.dhall-json-simple
    pkgs.nix-prefetch-git
    pkgs.cacert
  ];

  shellHook = ''
    export LIBRARY_PATH=${includePaths}
  '';
}
