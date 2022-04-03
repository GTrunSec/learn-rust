{
  description = "Rust development environment";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    flake-compat = {url = "github:edolstra/flake-compat"; flake = false; };
    rust-overlay = { url = "github:oxalica/rust-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    devshell = { url = "github:numtide/devshell"; inputs.nixpkgs.follows = "nixpkgs";};
  };

  outputs = inputs@{ self, nixpkgs, master, ...}:
    { }
    //
    (inputs.flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          overrideMaster = final: prev: {
            inherit (master.legacyPackages.${system})
              ;
          };
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlay
              inputs.rust-overlay.overlay
              inputs.devshell.overlay
              overrideMaster
            ];
            config = { };
          };
        in
        rec {
          packages = {
            inherit (pkgs.rust-bin.nightly.latest)
              default;
          };
          devShell = import ./devshell {inherit pkgs inputs;};
        })
    ) //
    {
      overlay = final: prev: { };
    };
}
