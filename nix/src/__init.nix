{
  inputs,
  omnibus,
  nixpkgs,
  eachSystem,
}:
omnibus.pops.load {
  src = ./.;
  inputs = {
    inputs = inputs // {
      inherit nixpkgs eachSystem;
    };
  };
}
