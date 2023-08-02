{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    crane.inputs.flake-compat.follows = "";
    crane.inputs.rust-overlay.follows = "rust-overlay";

    nix-filter.url = "github:/numtide/nix-filter";
    call-flake.url = "github:divnix/call-flake";
  };

  outputs =
    inputs@{ self, systems, ... }:
    let
      local = inputs.call-flake ./nix;
      eachSystem = inputs.nixpkgs.lib.genAttrs (import systems);
    in
    (eachSystem (
      system:
      let
        nixpkgs = inputs.nixpkgs.legacyPackages.${system}.appendOverlays [
          self.overlays.default
          inputs.rust-overlay.overlays.default
          inputs.nix-filter.overlays.default
        ];
      in
      {
        inherit nixpkgs;
        packages = { };
        devShells.default = local.devShells.${system}.default;
      }
    ))
    // {
      overlays = import ./nix/overlays.nix { inherit inputs; };
      inherit (local) __std;
    }
  ;
}
