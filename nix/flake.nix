{
  inputs.std.follows = "std-ext/std";
  inputs.std-ext.url = "github:gtrunsec/std-ext";
  inputs.nixpkgs.follows = "std-ext/nixpkgs";
  inputs.call-flake.url = "github:divnix/call-flake";

  outputs =
    { std, ... }@inputs:
    std.growOn
      {
        inputs = inputs // {
          local = inputs.call-flake ../.;
        };
        cellsFrom = ./cells;
        cellBlocks = with std.blockTypes; [
          # Development Environments
          (nixago "configs")
          (devshells "devshells")
        ];
      }
      {
        devShells = std.harvest inputs.self [
          "automation"
          "devshells"
        ];
      };
}
