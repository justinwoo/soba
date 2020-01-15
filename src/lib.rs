pub mod dhall;
pub mod nix;
pub mod psc_package;
pub mod types;

#[macro_export]
macro_rules! optional_line {
    ($id: ident) => {
        if !$id.is_empty() {
            format!("\n{}", $id)
        } else {
            "".to_owned()
        }
    };
}

#[macro_export]
macro_rules! handle_failure {
    ($program: expr, $output: ident) => {
        let stdout = String::from_utf8_lossy(&$output.stdout);
        let stderr = String::from_utf8_lossy(&$output.stderr);

        eprintln!(
            "{program} exited with non-zero status: {:?}{stdout}{stderr}",
            $output.status.code(),
            program = $program,
            stdout = super::optional_line!(stdout),
            stderr = super::optional_line!(stderr),
        );
        exit(1)
    };
}
