{ inputs }:
{
  default = final: prev: {
    rustEnv = final.fenix.fromToolchainFile {
      file = ../rust-toolchain.toml;
      sha256 = "sha256-R0F0Risbr74xg9mEYydyebx/z0Wu6HI0/KWwrV30vZo=";
    };
  };
}
