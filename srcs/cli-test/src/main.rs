use clap::{Arg, ArgAction, Command};

fn main() {
	let matches = Command::new("echor")
		.version("0.1.0")
		.author("author")
		.about("echo in Rust")
		.arg(
			Arg::new("text")
				.value_name("TEXT")
				.help("input text")
				.required(true)
				.action(ArgAction::Append),
		)
		.arg(
			Arg::new("omit newline")
				.short('n')
				.help("Don't print newline character")
				.action(ArgAction::SetTrue),
		)
		.get_matches();
	// let text: Vec<&str> = matches
	//     .get_many("text")
	//     .unwrap()
	//     .map(String::as_str)
	//     .collect();
	// let omit_newline = matches.get_flag("omit newline");
	// let ending = if omit_newline { "" } else { "\n" };
	//print!("{}{}", text.join(" "), ending);
	println!("{:#?}", matches);
}
