{ lib, config, pkgs, ... }:
let
  cfg = config.language.rust;
in
with pkgs;
with lib;
{
  options.language.rust = {
    rustOverlay = mkOption {
      type = types.attrs;
      default = pkgs.rust-set;
      description = "Which nightly rust version to use
      check valid data from https://github.com/oxalica/rust-overlay/tree/master/manifests/nightly";
    };

    rustPackages = mkOption {
      type = types.attrs;
      default = pkgs.rustPackages;
      description = "Which rust package set to use";
    };

    rustPackagesSet = mkOption {
      type = types.listOf types.str;
      default = [
      ];
      description = "Which rust tools to pull from the nixpkgs channel package set
      search valid packages here https://search.nixos.org/packages?channel=unstable&";
    };

    rustOverlaySet = mkOption {
      type = types.listOf types.str;
      default = [
        "default"
      ];
      description = "Which rust tools to pull from the rust overlay
      https://github.com/oxalica/rust-overlay/blob/master/manifests/profiles.nix";
    };
  };

  config = {
    env = [{
      # Used by tools like rust-analyzer
      name = "RUST_SRC_PATH";
      value = (toString rust-final) + "/lib/rustlib/src/rust/library";
    }];

    devshell.packages = map (tool: cfg.rustPackages.${tool}) cfg.rustPackagesSet
      ++ map (tool: cfg.rustOverlay.${tool}) cfg.rustOverlaySet ++ (with pkgs;[
      #custom nixpkgs packages
      rustracer
    ]);
  };
}
