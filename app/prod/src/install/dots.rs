use fs_extra::dir::{copy as copy_dir, CopyOptions};
use dirs::home_dir;

pub fn run() -> std::io::Result<()> {
    // get repo root (assuming current working dir is the root, otherwise adjust)
    let repo_dots = home_dir()
        .expect("could not find $HOME")
        .join(".luna")
        .join("dots");

    if !repo_dots.exists() {
        panic!("could not find {:?}", repo_dots);
    }

    // get $HOME/.config/
    let home = home_dir().expect("could not find home directory");
    let config_dir = home.join(".config");

    // copy options: recursive, overwrite existing files
    let mut options = CopyOptions::new();
    options.overwrite = true;
    options.copy_inside = true; // copy *contents* of dots, not dots itself

    // do the copy
    copy_dir(repo_dots, &config_dir, &options)
        .map(|_| ())
        .map_err(|e| std::io::Error::new(std::io::ErrorKind::Other, e))
}
