{
  lib,
  config,
  pkgs,
  modulePath,
  ...
}:
let
  rust-bin = pkgs.rustEnv;
in
{
  packagesFrom = [ ];
  packages = [
    pkgs.pkg-config
    pkgs.rustup
    pkgs.clang
  ];
  # language.rust = {
  #   packageSet = rust-bin;
  #   enableDefaultToolchain = true;
  #   tools = ["toolchain"]; # fenix collates them all in a convenience derivation
  # };
  devshell.startup.link-cargo-home = {
    deps = [ ];
    text = ''
      # ensure CARGO_HOME is populated
      mkdir -p $PRJ_DATA_DIR/cargo
      ln -sf -t $PRJ_DATA_DIR/cargo $(ls -d ${rust-bin.outPath}/*)
    '';
  };

  env = [
    {
      # ensures subcommands are picked up from the right place
      # but also needs to be writable; see link-cargo-home above
      name = "CARGO_HOME";
      eval = "$PRJ_DATA_DIR/cargo";
    }
    {
      # ensure we know where rustup_home will be
      name = "RUSTUP_HOME";
      eval = "$PRJ_DATA_DIR/rustup";
    }
    {
      name = "RUST_SRC_PATH";
      # accessing via toolchain doesn't fail if it's not there
      # and rust-analyzer is graceful if it's not set correctly:
      # https://github.com/rust-lang/rust-analyzer/blob/7f1234492e3164f9688027278df7e915bc1d919c/crates/project-model/src/sysroot.rs#L196-L211
      value = "${rust-bin.outPath}/lib/rustlib/src/rust/library";
    }
    {
      name = "PKG_CONFIG_PATH";
      value = lib.makeSearchPath "lib/pkgconfig" [
        pkgs.openssl.dev
        pkgs.libiconv
      ];
    }
    {
      name = "LIBRARY_PATH";
      value = lib.makeLibraryPath [ pkgs.libiconv ];
    }
  ];
  commands =
    [
      # {
      #   package = std.cli.default;
      #   category = "std";
      # }
    ];
}
