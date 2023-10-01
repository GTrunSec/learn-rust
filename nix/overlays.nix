{ inputs }:
{
  default = final: prev: {
    rustEnv = final.fenix.fromToolchainFile {
      file = ../rust-toolchain.toml;
      sha256 = "sha256-dxE7lmCFWlq0nl/wKcmYvpP9zqQbBitAQgZ1zx9Ooik=";
    };
  };
}
