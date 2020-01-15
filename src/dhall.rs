use std::fs;
use std::path::Path;
use std::process::{exit, Command};

use crate::handle_failure;

// convert the packages dhall to json via `dhall-to-json --file packages.dhall`
pub fn packages_dhall_to_json() -> String {
    let output = Command::new("dhall-to-json")
        .arg("--file")
        .arg("packages.dhall")
        .output()
        .expect("Could not launch dhall-to-json. Make sure you have it in PATH.");

    if output.status.success() {
        let stdout = String::from_utf8_lossy(&output.stdout);
        stdout.to_string()
    } else {
        handle_failure!("dhall-to-json", output);
    }
}

pub fn init_packages_dhall() {
    let target = Path::new("packages.dhall");

    if !target.exists() {
        fs::write(target, PACKAGES_DHALL).expect("Could not write packages.dhall.");
        eprintln!("Wrote local setup initial packages.dhall.");
    } else {
        eprintln!("packages.dhall already exists, did nothing.");
    }
}

pub const PACKAGES_DHALL: &str = "https://github.com/purescript/package-sets/releases/download/psc-0.13.5-20200103/packages.dhall sha256:0a6051982fb4eedb72fbe5ca4282259719b7b9b525a4dda60367f98079132f30";

pub fn update_packages_dhall() {
    let output = Command::new("dhall")
        .arg("freeze")
        .arg("--inplace")
        .arg("packages.dhall")
        .output()
        .expect("Could not launch dhall. Make sure you have it in PATH.");

    if output.status.success() {
        eprintln!("Updated packages.dhall.");
    } else {
        handle_failure!("dhall", output);
    }
}
