use serde::{Deserialize, Serialize};

pub type PackageName = String;
pub type RepoUrl = String;
pub type Version = String;
pub type Rev = String;
pub type Sha256 = String;

// a psc-package package
// { repo: "https://github.com/justinwoo/purescript-simple-json.git"
// , version: "v1.0.0" }
#[derive(Serialize, Deserialize, Debug)]
pub struct Package {
    pub repo: RepoUrl,
    pub version: Version,
}

pub struct PackageInfo {
    pub name: String,
    pub repo: RepoUrl,
    pub version: Version,
}

// nix-prefetch-git result
// "url": "https://github.com/slamdata/purescript-aff.git",
// "rev": "390857f9143e1a52f7403d05b14c9ca79d356737",
// "sha256": "19v5psd6jz13gr5yqyx8286b5bpfq1dax51w906y0mqgnfz92yzr",
#[derive(Serialize, Deserialize)]
pub struct PrefetchResult {
    pub url: RepoUrl,
    pub rev: Rev,
    pub sha256: Sha256,
}

// pub struct DrvInputs {
//     pub name: PackageName,
//     pub version: Version,
//     pub url: PackageName,
//     pub rev: String,
//     pub sha256: String,
// }
