use assert_cmd::Command;
use predicates::prelude::*;

#[test]
fn run() {
	let mut cmd = Command::cargo_bin("cli-test").unwrap();
	// cmd.assert().success().stdout("Hello, world!!\n");
	cmd.arg("hello").assert().success();
}
#[test]
fn diagnose() {
	let mut cmd = Command::cargo_bin("cli-test").unwrap();
	cmd.arg("-V").assert().success().stdout(predicate::str::contains("echor 0.1.0"));
}
