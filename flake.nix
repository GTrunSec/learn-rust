{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    crane.url = "github:nmattia/naersk";
    crane.inputs.nixpkgs.follows = "nixpkgs";

    nix-filter.url = "github:/numtide/nix-filter";
    call-flake.url = "github:divnix/call-flake";
  };

  outputs =
    inputs@{
      self,
      systems,
      ...
    }:
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
      rec {
        inherit nixpkgs;
        packages = { };
        devShells.default = local.devShells.${system}.default;
      }
    )) // {
      overlays = import ./nix/overlays.nix { inherit inputs; };
      inherit (local) __std;
    }
  ;
}
