/* This file holds reproducible shells with commands in them.

   They conveniently also generate config files in their startup hook.
*/
{ inputs, cell }:
let
  inherit (inputs.std) lib;
  inherit (inputs) std local;
  inherit (inputs) nixpkgs;
  l = nixpkgs.lib // builtins;

  devshellProfiles =
    local.loadDevShell.${nixpkgs.system}.loadProfiles.outputs.default;
in
{
  # Tool Homepage: https://numtide.github.io/devshell/
  default = lib.dev.mkShell {
    name = "Rust Development Env";
    imports = [
      # "${inputs.std.inputs.devshell}/extra/language/rust.nix"
      (inputs.local + "/nix/rust.nix")
      devshellProfiles.rust
      (std.inputs.devshell.lib.importTOML (inputs.local + "/devshell.toml"))
    ];
    # Tool Homepage: https://nix-community.github.io/nixago/
    # This is Standard's devshell integration.
    # It runs the startup hook when entering the shell.
    nixago = [
      # lib.cfg.conform
      ((lib.dev.mkNixago lib.cfg.conform) {
        data = {
          inherit (inputs) cells;
        };
      })
      (inputs.std-ext.presets.nixago.treefmt
        inputs.std-ext.presets.configs.treefmt.rust
      )
      (lib.dev.mkNixago lib.cfg.editorconfig cell.configs.editorconfig)
      (lib.dev.mkNixago lib.cfg.githubsettings cell.configs.githubsettings)
      (lib.dev.mkNixago lib.cfg.lefthook cell.configs.lefthook)
    ];

    commands = [ {
      name = "std";
      help = std.packages.std.meta.description;
      command = ''
        (cd $PRJ_ROOT/nix && ${std.packages.std}/bin/std)
      '';
    } ];
  };
}
