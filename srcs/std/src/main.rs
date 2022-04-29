use walkdir::WalkDir;
use std::env;

fn main() {
    for entry in WalkDir::new(".") {
        let entry = entry.unwrap();
        println!("{}", entry.path().display());
    }
}
