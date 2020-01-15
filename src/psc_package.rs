use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::{exit, Command};

use crate::dhall::packages_dhall_to_json;
use crate::handle_failure;
use crate::types::*;

pub fn get_packages_json_path() -> PathBuf {
    let dir = Path::new(".psc-package/local/.set");
    let mut target = PathBuf::new();
    target.push(dir);
    target.push("packages.json");

    fs::create_dir_all(dir).expect("Could not create directories for local package set.");

    target
}

pub fn write_local_package_set() {
    let json = packages_dhall_to_json();

    let target = get_packages_json_path();

    fs::write(target, json).expect("Could not write target local package set file.");

    eprintln!("Wrote local package set using packages.dhall.");
}

pub fn init() {
    let target = Path::new("psc-package.json");

    if !target.exists() {
        fs::write(target, PSC_PACKAGE_JSON).expect("Could not write psc-package.json.");
        eprintln!("Wrote local setup initial psc-package.json.");
    } else {
        eprintln!("psc-package.json already exists, did nothing.");
    }
}

// get full dependencies list from psc-package
pub fn get_dependencies() -> Vec<PackageName> {
    let output = Command::new("psc-package")
        .arg("dependencies")
        .output()
        .expect("Could not launch psc-package. Make sure you have it in PATH.");

    if output.status.success() {
        let stdout = String::from_utf8_lossy(&output.stdout);
        let string = stdout.to_string();
        string
            .split("\n")
            .filter_map(|string| {
                if string.is_empty() {
                    None
                } else {
                    Some(string.to_owned())
                }
            })
            .collect()
    } else {
        handle_failure!("psc_package", output);
    }
}

pub fn get_packages() -> HashMap<PackageName, Package> {
    let target = get_packages_json_path();
    let string = fs::read_to_string(target)
        .expect("Could not read packages.json. Have you set up the psc-package.json file?");
    serde_json::from_str(&string)
        .expect("Error: could not parse packages.json. This file may be corrupted.")
}

pub const PSC_PACKAGE_JSON: &str = r#"{
  "name": "name",
  "set": "local",
  "source": ".psc-package",
  "depends": [
    "console",
    "prelude"
  ]
}"#;
