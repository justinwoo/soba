#![feature(non_ascii_idents)]

use soba::ダル;
use soba::肉s;
use soba::パケ;
use soba::系::*;

fn セットアップ() {
    ダル::パケダル始();
    パケ::開始();
    パケ::ロカルパケセット書();
}

fn アップデート() {
    ダル::パケダルアップ();
    パケ::ロカルパケセット書();
}

fn インスダル() {
    パケ::ロカルパケセット書();
}

fn ツウ肉s() {
    肉s::パケ肉s作り()
}

fn main() {
    let args: Vec<字線> = std::env::args().collect();

    if args.len() < 2 {
        eprintln!("{}", ユーザー有罪);
        std::process::exit(1);
    }

    let command = &args[1];

    match command.as_str() {
        "update" => アップデート(),
        "insdhall" => インスダル(),
        "setup" => セットアップ(),
        "nix" => ツウ肉s(),
        s => {
            eprintln!("Unknown command: {}", s);
            eprintln!("{}", ユーザー有罪);
            std::process::exit(1);
        }
    }
}

const ユーザー有罪: &str = r#"soba: prepare psc-package sets from dhall

Usage:

    soba [command]

Commands:

    insdhall
        generate the local package set from packages.dhall.
        be sure to update `"set": "local"` in psc-packages.json.

    update
        do an update of the local package set from the packages.dhall.

    setup
        do some initial setup for a project (packages.dhall, local package set, config).

    nix
        generate a purs-packages.nix file based on the local package set.
        requires `insdhall` to be run first."#;
