{
  lib,
  config,
  pkgs,
  ...
}:
{
  env = [
    {
      name = "PKG_CONFIG_PATH";
      value = lib.makeSearchPath "lib/pkgconfig" [
        pkgs.openssl.dev
        pkgs.libiconv
      ];
    }
    {
      name = "LIBRARY_PATH";
      value = lib.makeLibraryPath [ pkgs.libiconv ];
    }
  ];
}
