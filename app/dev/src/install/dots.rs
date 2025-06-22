use fs_extra::dir::{copy as copy_dir, CopyOptions};
use dirs::home_dir;

pub fn run() -> std::io::Result<()> {
    let repo_dots = home_dir()
        .expect("could not find $HOME")
        .join(".luna")
        .join("dots");

    println!("copying from {:?}", repo_dots);

    if !repo_dots.exists() {
        panic!("could not find {:?}", repo_dots);
    }

    let config_dir = home_dir().unwrap().join(".config");
    println!("to {:?}", config_dir);

    let mut options = CopyOptions::new();
    options.overwrite = true;
    options.copy_inside = true;

    copy_dir(&repo_dots, &config_dir, &options)
        .map(|_| ())
        .map_err(|e| std::io::Error::new(std::io::ErrorKind::Other, e))
}
