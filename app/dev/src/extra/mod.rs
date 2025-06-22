pub fn lesbian() {
    // comment
    let line = "you say you a lesbian girl me too";
    for &color in [160, 202, 209, 7, 205, 169, 162].iter() {
        println!("\x1b[38;5;{}m{}\x1b[0m", color, line);
    }
}

pub fn version() {
    println!("{} {}", env!("CARGO_PKG_NAME"),  env!("CARGO_PKG_VERSION"));
}