/* This file holds reproducible shells with commands in them.

   They conveniently also generate config files in their startup hook.
*/
{ inputs, cell }:
let
  inherit (inputs.std) lib;
  inherit (inputs) std;
  nixpkgs = inputs.local.nixpkgs;
  l = nixpkgs.lib // builtins;
in
{
  # Tool Homepage: https://numtide.github.io/devshell/
  default = lib.dev.mkShell {
    name = "Rust Development Env";
    _module.args.pkgs = nixpkgs;
    imports = [
      # "${inputs.std.inputs.devshell}/extra/language/rust.nix"
      (inputs.local + "/nix/rust.nix")
      (std.inputs.devshell.lib.importTOML (inputs.local + "/devshell.toml"))
      inputs.std.std.devshellProfiles.default
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
      (inputs.std-ext.preset.nixago.treefmt
        inputs.std-ext.preset.configs.treefmt.rust
      )
      (lib.dev.mkNixago lib.cfg.editorconfig cell.configs.editorconfig)
      (lib.dev.mkNixago lib.cfg.githubsettings cell.configs.githubsettings)
      (lib.dev.mkNixago lib.cfg.lefthook cell.configs.lefthook)
    ];

    commands = [ ];
    # packages = [ nixpkgs.rustEnv ];
  };
}
