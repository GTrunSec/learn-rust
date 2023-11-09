{
  inputs.omnibus-std.url = "github:gtrunsec/omnibus?dir=local";
  inputs.nixpkgs.follows = "omnibus-std/nixpkgs";
  inputs.std.follows = "omnibus-std/std";
  inputs.call-flake.url = "github:divnix/call-flake";

  outputs =
    { std, ... }@inputs:
    std.growOn
      {
        inputs = inputs // rec {
          main = inputs.call-flake ../../.;
        };
        cellsFrom = ./cells;
        cellBlocks = with std.blockTypes; [
          # Development Environments
          (nixago "configs")
          (functions "pops")
          (devshells "shells")
        ];
      }
      {
        devShells = std.harvest inputs.self [
          "repo"
          "shells"
        ];
      };
}
