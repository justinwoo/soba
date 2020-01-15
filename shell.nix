{ pkgs ? import ./pinned.nix {} }:

let

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
pkgs.mkShell {
  buildInputs = [
    easy-ps.purs
    easy-ps.psc-package
    easy-dhall.dhall-simple
    easy-dhall.dhall-json-simple
    pkgs.nix-prefetch-git
    pkgs.cacert
  ];
}
