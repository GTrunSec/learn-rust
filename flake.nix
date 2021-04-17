{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/7d71001b796340b219d1bfa8552c81995017544a";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    devshell-flake.url = "github:numtide/devshell";
    mach-nix = { url = "github:DavHau/mach-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, flake-compat, rust-overlay, devshell-flake, mach-nix }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          machLib = import mach-nix
            {
              # pypiDataRev = pypi-deps-db.rev;
              # pypiDataSha256 = pypi-deps-db.narHash;
              python = "python38";
              inherit pkgs;
            };

          unstable = final: prev: {
            inherit ((import inputs.master) { inherit system; })
              ;
          };
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              (import rust-overlay)
              devshell-flake.overlay
              #unstable
            ];
            config = { };
          };
        in
        rec {

          python-packages-custom = machLib.mkPython rec {
            requirements = ''
              mkdocs-awesome-pages-plugin
              mkdocs-material
              setuptools
            '';
          };

          packages = {
            inherit (pkgs.rust-bin.nightly.latest)
              default;
            inherit (pkgs)
              rustracer;
          };
          devShell = with pkgs; devshell.mkShell {
            imports = [
              ./nix/rust.nix
              (devshell.importTOML ./nix/commands.toml)
            ];
            packages = [
              python-packages-custom
            ];
            env = [
              {
                name = "DIR";
                prefix = ''
                  $( cd "$(dirname "$\{\BASH_SOURCE [ 0 ]}")"; pwd )
                '';
              }
            ];
          };
        })
    ) //
    {
      overlay = final: prev: {
        rust-set = final.rust-bin.nightly.latest;
        rust-final = final.rust-bin.nightly.latest.default.override {
          extensions = [ "rust-src" ];
        };
      };
    };
}
