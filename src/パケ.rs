use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::{exit, Command};

use crate::ダル::パケダルツウジェソン;
use crate::失敗処理;
use crate::系::*;

pub fn パケジェソンパスゲット() -> PathBuf {
    let dir = Path::new(".psc-package/local/.set");
    let mut target = PathBuf::new();
    target.push(dir);
    target.push("packages.json");

    fs::create_dir_all(dir).expect("Could not create directories for local package set.");

    target
}

pub fn ロカルパケセット書() {
    let json = パケダルツウジェソン();

    let target = パケジェソンパスゲット();

    fs::write(target, json).expect("Could not write target local package set file.");

    eprintln!("Wrote local package set using packages.dhall.");
}

pub fn 開始() {
    let target = Path::new("psc-package.json");

    if !target.exists() {
        fs::write(target, パケ_JSON).expect("Could not write psc-package.json.");
        eprintln!("Wrote local setup initial psc-package.json.");
    } else {
        eprintln!("psc-package.json already exists, did nothing.");
    }
}

pub fn デプ取り() -> Vec<パケ名> {
    let output = Command::new("psc-package")
        .arg("dependencies")
        .output()
        .expect("Could not launch psc-package. Make sure you have it in PATH.");

    if output.status.success() {
        let stdout = 字線::from_utf8_lossy(&output.stdout);
        let 字線 = stdout.to_string();
        字線
            .split("\n")
            .filter_map(|字線| {
                if 字線.is_empty() {
                    None
                } else {
                    Some(字線.to_owned())
                }
            })
            .collect()
    } else {
        失敗処理!("psc-package", output);
    }
}

pub fn パケゲット() -> HashMap<パケ名, パケ> {
    let target = パケジェソンパスゲット();
    let 字線 = fs::read_to_string(target)
        .expect("Could not read packages.json. Have you set up the psc-package.json file?");
    serde_json::from_str(&字線)
        .expect("Error: could not parse packages.json. This file may be corrupted.")
}

pub const パケ_JSON: &str = r#"{
  "name": "name",
  "set": "local",
  "source": ".psc-package",
  "depends": [
    "console",
    "prelude"
  ]
}"#;
