{ lib, config, pkgs, ... }:
let
  cfg = config.language.rust;
  date = "latest";
in
with pkgs;
with lib;
{
  options.language.rust = {
    rust-bin = mkOption {
      type = types.attrs;
      default = pkgs.rust-bin.nightly."${date}";
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
      default = [ ];
      description = "Which rust tools to pull from the nixpkgs channel package set
      search valid packages here https://search.nixos.org/packages?channel=unstable&";
    };

    rustOverlaySet = mkOption {
      type = types.listOf types.str;
      default = [
        "rust-analyzer-preview"
      ];
      description = "Which rust tools to pull from the rust overlay
      https://github.com/oxalica/rust-overlay/blob/master/manifests/profiles.nix";
    };
  };

  config = {
    devshell.packages = map (tool: cfg.rustPackages.${tool}) cfg.rustPackagesSet
      ++ map (tool: cfg.rust-bin.${tool}) cfg.rustOverlaySet ++ (with pkgs;[
      #custom nixpkgs packages
      (cfg.rust-bin.default.override
        {
          extensions = [ "rust-src" ];
        })
    ]);
  };
}
