#!/usr/bin/env nix-shell
#!nix-shell shell.nix -i bash

set -e;

cargo build;

SOBA="$(pwd)/target/debug/soba"

rm -rf .psc-package || true
rm -rf output || true
rm psc-package.json || true
rm packages.dhall || true

$SOBA setup
psc-package build

$SOBA update
$SOBA insdhall
psc-package build
