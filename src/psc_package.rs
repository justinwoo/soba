use std::fs;
use std::path::{Path, PathBuf};

use crate::dhall::packages_dhall_to_json;

pub fn write_local_package_set() {
    let json = packages_dhall_to_json();

    let dir = Path::new(".psc-package/local/.set");
    let mut target = PathBuf::new();
    target.push(dir);
    target.push("packages.json");

    fs::create_dir_all(dir).expect("Could not create directories for local package set.");
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

pub const PSC_PACKAGE_JSON: &str = r#"{
  "name": "name",
  "set": "local",
  "source": ".psc-package",
  "depends": [
    "console",
    "prelude"
  ]
}"#;
