{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
    master.url = "nixpkgs/nixos-unstable";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    devshell-flake.url = "github:numtide/devshell";
    mach-nix = { url = "github:DavHau/mach-nix"; inputs.nixpkgs.follows = "nixpkgs"; inputs.pypi-deps-db.follows = "pypi-deps-db"; };
    pypi-deps-db = {
      url = "github:DavHau/pypi-deps-db";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, master, pypi-deps-db, flake-utils, flake-compat, rust-overlay, devshell-flake, mach-nix }:
    { }
    //
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          unstable = final: prev: {
            inherit ((import master) { inherit system; })
              ;
          };
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              rust-overlay.overlay
              devshell-flake.overlay
              unstable
            ];
            config = { };
          };
        in
        rec {
          python-packages-custom = pkgs.machlib.mkPython {
            ignoreDataOutdated = true;
            requirements = ''
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
              (devshell.importTOML ./nix/devshell.toml)
            ];
            packages = [
              python-packages-custom #comment
              nixpkgs-fmt
            ];
            env = [ ];
          };
        })
    ) //
    {
      overlay = final: prev: {
        machlib = import mach-nix
          {
            pypiDataRev = pypi-deps-db.rev;
            pypiDataSha256 = pypi-deps-db.narHash;
            python = "python39";
            pkgs = prev;
          };
      };
    };
}
