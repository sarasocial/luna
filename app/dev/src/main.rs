use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "luna")]
#[command(version, about = "cli app by very sane woman", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Subcommand)]
enum Commands {
    Install,
    Lesbian,
    Version,
    // add more as you go!
}

mod luna;
mod install;
mod extra;
use extra::lesbian;
use extra::version;

fn main() {
    let cli = Cli::parse();

    match &cli.command {
        Some(Commands::Install) => install::run(),
        Some(Commands::Lesbian) => lesbian(),
        Some(Commands::Version) => version(),
        None => luna::run()
    }
}

