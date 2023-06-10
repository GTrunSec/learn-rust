// use std::net::TcpListener;
// use zero2prod::run;

// #[tokio::main]
// async fn main() -> std::io::Result<()> {
//     let address = TcpListener::bind("127.0.0.1:8000")?;
//     run(address)?.await
// }

// use actix_web::{web, App, HttpRequest, HttpServer, Responder};
// async fn greet(req: HttpRequest) -> impl Responder {
// 	let name = req.match_info().get("name").unwrap_or("World");
// 	format!("Hello {}!", &name)
// }

// #[tokio::main]
// async fn main() -> std::io::Result<()> {
// 	HttpServer::new(|| {
// 		App::new()
// 			.route("/", web::get().to(greet))
// 			.route("/{name}", web::get().to(greet))
// 	})
// 	.bind("127.0.0.1:8000")?
// 	.run()
// 	.await
// }

use std::fs;

fn main() {
	let url = "https://www.rust-lang.org";
	let output = "rust.md";
	println!("Fetching url: {}", url);
	let body = reqwest::blocking::get(url).unwrap().text().unwrap();
	println!("Converting html to markdown...");
	let md = html2md::parse_html(&body);
	fs::write(output, md.as_bytes()).unwrap();
	println!("Converted markdown has been saved in {}.", output);
}
