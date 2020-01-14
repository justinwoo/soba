#!/usr/bin/env nix-shell
#!nix-shell shell.nix -i bash

set -e;

SOBA="$(pwd)/target/debug/soba"

rm -rf .psc-package
rm -rf output
rm psc-package.json
rm packages.dhall

$SOBA setup
psc-package build

$SOBA update
$SOBA insdhall
psc-package build
