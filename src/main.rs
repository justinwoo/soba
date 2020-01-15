use soba::dhall;
use soba::nix;
use soba::psc_package;

fn setup() {
    dhall::init_packages_dhall();
    psc_package::init();
    psc_package::write_local_package_set();
}

fn update() {
    dhall::update_packages_dhall();
    psc_package::write_local_package_set();
}

fn insdhall() {
    psc_package::write_local_package_set();
}

fn to_nix() {
    nix::make_purs_packages_nix()
}

fn main() {
    let args: Vec<String> = std::env::args().collect();

    if args.len() < 2 {
        eprintln!("{}", USAGE_ERROR);
        std::process::exit(1);
    }

    let command = &args[1];

    match command.as_str() {
        "update" => update(),
        "insdhall" => insdhall(),
        "setup" => setup(),
        "nix" => to_nix(),
        s => {
            eprintln!("Unknown command: {}", s);
            eprintln!("{}", USAGE_ERROR);
            std::process::exit(1);
        }
    }
}

const USAGE_ERROR: &str = r#"soba: prepare psc-package sets from dhall

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
