{ pkgs, inputs, }:

pkgs.devshell.mkShell {
  imports = [
    ./rust.nix
    (pkgs.devshell.importTOML ./devshell.toml)
  ];
  packages = [];
  env = [ ];
}
