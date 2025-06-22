use dirs::home_dir;
use std::fs;

pub fn run() -> std::io::Result<()> {
    let dots = home_dir().unwrap().join(".luna").join("dots");
    let config = home_dir().unwrap().join(".config");

    for entry in fs::read_dir(&dots)? {
        let entry = entry?;
        let src = entry.path();
        let dst = config.join(entry.file_name());
        if src.is_dir() {
            let _ = fs_extra::dir::copy(&src, &config, &{
                let mut options = fs_extra::dir::CopyOptions::new();
                options.overwrite = true;
                options.copy_inside = false; // copying *this dir* into config
                options
            });
        } else {
            fs::copy(&src, &dst)?;
        }
    }
    Ok(())
}