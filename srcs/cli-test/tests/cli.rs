use assert_cmd::Command;

#[test]
fn run() {
	let mut cmd = Command::cargo_bin("hello").unwrap();
	cmd.assert().success().stdout("Hello, world!!\n");
}
