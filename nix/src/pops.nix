{ inputs }:
let
  inherit (inputs) eachSystem;
in
(rec {
  __inputs__ = eachSystem (
    system: (inputs.omnibus.pops.flake.setInitInputs inputs).setSystem system
  );
  devshellProfiles = eachSystem (
    system:
    inputs.omnibus.pops.devshellProfiles.addLoadExtender {
      load.inputs = {
        inputs = __inputs__.${system}.inputs;
      };
    }
  );
})
