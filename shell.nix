{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, base64-bytestring, bytestring
      , cryptohash, directory, hspec, postgresql-simple, safe-exceptions
      , stdenv, text, time, postgresql
      }:
      mkDerivation {
        pname = "postgresql-simple-migration";
        version = "0.1.9.1";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          base base64-bytestring bytestring cryptohash directory
          postgresql-simple safe-exceptions time postgresql
        ];
        executableHaskellDepends = [
          base base64-bytestring bytestring cryptohash directory
          postgresql-simple safe-exceptions text time
        ];
        testHaskellDepends = [ base bytestring hspec postgresql-simple ];
        homepage = "https://github.com/ameingast/postgresql-simple-migration";
        description = "PostgreSQL Schema Migrations";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
