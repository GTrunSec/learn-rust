{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    crane.inputs.flake-compat.follows = "";
    crane.inputs.rust-overlay.follows = "";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    nix-filter.url = "github:/numtide/nix-filter";
    POS.url = "github:GTrunSec/POS";
  };

  outputs =
    inputs@{ self, systems, ... }:
    let
      eachSystem = inputs.nixpkgs.lib.genAttrs (import systems);
      nixpkgs = eachSystem (
        system:
        inputs.nixpkgs.legacyPackages.${system}.appendOverlays [
          self.overlays.default
          inputs.fenix.overlays.default
          inputs.nix-filter.overlays.default
        ]
      );
    in
    {
      loadDevShell = eachSystem (
        system: rec {
          loadInputs =
            (inputs.POS.lib.loadInputs.setInitInputs (inputs // { inherit nixpkgs; }))
            .setSystem
              system;
          profiles = inputs.POS.lib.evalModules.devshell.loadProfiles.addLoadExtender {
            inputs = loadInputs.outputs;
          };
        }
      );
      overlays = import ./nix/overlays.nix { inherit inputs; };
    };
}
