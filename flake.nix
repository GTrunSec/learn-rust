{
  description = "Rust development environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    crane.url = "github:nmattia/naersk";
    crane.inputs.nixpkgs.follows = "nixpkgs";

    nix-filter.url = "github:/numtide/nix-filter";
    nix-filter.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      flake-utils,
      ...
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        nixpkgs = inputs.nixpkgs.legacyPackages.${system}.appendOverlays [
          self.overlays.default
          inputs.rust-overlay.overlays.default
          inputs.nix-filter.overlays.default
        ];
      in
      rec {
        inherit nixpkgs;
        packages = { };
      }
    )) // {
      overlays = import ./nix/overlays.nix { inherit inputs; };
    }
    ;
}
