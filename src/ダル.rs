use std::fs;
use std::path::Path;
use std::process::{exit, Command};

use crate::系::*;
use crate::失敗処理;

pub fn パケダルツウジェソン() -> 字線 {
    let output = Command::new("dhall-to-json")
        .arg("--file")
        .arg("packages.dhall")
        .output()
        .expect("Could not launch dhall-to-json. Make sure you have it in PATH.");

    if output.status.success() {
        let stdout = 字線::from_utf8_lossy(&output.stdout);
        stdout.to_string()
    } else {
        失敗処理!("dhall-to-json", output);
    }
}

pub fn パケダル始() {
    let target = Path::new("packages.dhall");

    if !target.exists() {
        fs::write(target, パケダル).expect("Could not write packages.dhall.");
        eprintln!("Wrote local setup initial packages.dhall.");
    } else {
        eprintln!("packages.dhall already exists, did nothing.");
    }
}

pub const パケダル: &str = "https://github.com/purescript/package-sets/releases/download/psc-0.13.5-20200103/packages.dhall sha256:0a6051982fb4eedb72fbe5ca4282259719b7b9b525a4dda60367f98079132f30";

pub fn パケダルアップ() {
    let output = Command::new("dhall")
        .arg("freeze")
        .arg("--inplace")
        .arg("packages.dhall")
        .output()
        .expect("Could not launch dhall. Make sure you have it in PATH.");

    if output.status.success() {
        eprintln!("Updated packages.dhall.");
    } else {
        失敗処理!("dhall", output);
    }
}
