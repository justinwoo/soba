{ pkgs ? import ./pinned.nix {} }:

let

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
