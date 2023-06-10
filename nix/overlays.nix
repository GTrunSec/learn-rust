{
  inputs,
}: {
  default =
    final: prev: {
      rustEnv = final.rust-bin.fromRustupToolchainFile ../rust-toolchain.toml;
      # rustEnv = final.rust-bin.stable.latest.default.override {
      #   extensions = [ "rust-src" ];
      # };
    }
    ;
}
