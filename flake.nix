{
  description = "Rust development environment";
  nixConfig = {
    flake-registry = "https://github.com/hardenedlinux/flake-registry/raw/main/flake-registry.json";
  };

  inputs = {
    flake-compat.flake = false;
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    devshell.url = "github:numtide/devshell";
  };

  outputs = inputs@{ self, nixpkgs, unstable, flake-utils, flake-compat, rust-overlay, devshell }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          unstable = final: prev: {
            inherit ((import unstable) { inherit system; })
              ;
          };
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              rust-overlay.overlay
              devshell.overlay
              unstable
            ];
            config = { };
          };
        in
        rec {
          packages = {
            inherit (pkgs.rust-bin.nightly.latest)
              default;
          };
          devShell = with pkgs; pkgs.devshell.mkShell {
            imports = [
              ./nix/rust.nix
              (pkgs.devshell.importTOML ./nix/devshell.toml)
            ];
            packages = [
              nixpkgs-fmt
            ];
            env = [ ];
          };
        })
    ) //
    {
      overlay = final: prev: { };
    };
}
