use serde::{Deserialize, Serialize};

pub type 字線 = String;

pub type パケ名 = 字線;
pub type レポウレ = 字線;
pub type 馬ジョン = 字線;
pub type レボ = 字線;
pub type 社 = 字線;

// { repo: "https://github.com/justinwoo/purescript-simple-json.git"
// , 馬ジョン: "v1.0.0" }
#[derive(Serialize, Deserialize, Debug)]
pub struct パケ {
    pub repo: レポウレ,
    pub version: 馬ジョン,
}

pub struct パケ情報 {
    pub name: 字線,
    pub repo: レポウレ,
    pub version: 馬ジョン,
}

// "url": "https://github.com/slamdata/purescript-aff.git",
// "レボ": "390857f9143e1a52f7403d05b14c9ca79d356737",
// "社": "19v5psd6jz13gr5yqyx8286b5bpfq1dax51w906y0mqgnfz92yzr",
#[derive(Serialize, Deserialize)]
pub struct 先取り結果 {
    pub url: レポウレ,
    pub rev: レボ,
    pub sha256: 社,
}
