{ pkgs ? import ./pinned.nix {} }:

let

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
