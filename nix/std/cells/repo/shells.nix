/* This file holds reproducible shells with commands in them.

   They conveniently also generate config files in their startup hook.
*/
{ inputs, cell }:
let
  inherit (inputs.std) lib;
  inherit (inputs) std main;
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;

  devshellProfiles = main.pops.devshellProfiles.${nixpkgs.system}.layouts.default;
in
{
  # Tool Homepage: https://numtide.github.io/devshell/
  default = lib.dev.mkShell {
    name = "Rust Development Env";
    imports = [
      # "${inputs.std.inputs.devshell}/extra/language/rust.nix"
      (inputs.main + "/nix/rust.nix")
      devshellProfiles.rust
      (std.inputs.devshell.lib.importTOML (inputs.main + "/devshell.toml"))
    ];
    # Tool Homepage: https://nix-community.github.io/nixago/
    # This is Standard's devshell integration.
    # It runs the startup hook when entering the shell.
    nixago = [
      cell.configs.treefmt.default
      cell.configs.conform.default
      cell.configs.lefthook.default
    ];

    commands = [
      {
        name = "std";
        help = std.packages.std.meta.description;
        command = ''
          (cd $PRJ_ROOT/nix && ${std.packages.std}/bin/std)
        '';
      }
    ];
  };
}
