# Nix package for yafca ("yet another finance cli app"); installs the `fca` binary.
#
# Self-contained: the source is fetched from GitHub, so this file can live anywhere
# (e.g. in your NixOS configuration repo) and is used with callPackage:
#
#   environment.systemPackages = [ (pkgs.callPackage ./yafca.nix { }) ];
#
# To update: change `rev`, set both hashes to lib.fakeHash, build once, and copy the
# "got:" hash from each of the two mismatch errors (first `hash`, then `cargoHash`).
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "yafca";
  version = "0.1.0-unstable-2026-11-10";

  src = fetchFromGitHub {
    owner = "j0shk0";
    repo = "yacfa";
    rev = "e35927d49eb420c8651e933a7bfd4313a3c370e0";
    hash = "sha256-3IrLbUkbq8EcELsdPUnEPttbS7bgZYqL5KwFJ+K/srU=";
  };

  # Hash of the vendored Cargo dependencies; changes whenever Cargo.lock changes.
  cargoHash = "sha256-/+wn+HiA+pGEfsA0Tbea2j8DwqAsibc9QkseMfZlFmg=";

  # The workspace has four crates; only fca-cli produces a binary.
  cargoBuildFlags = [
    "--package"
    "fca-cli"
  ];
  cargoTestFlags = [ "--workspace" ];

  postInstall = ''
    install -Dm444 config.example.toml $out/share/yafca/config.example.toml
  '';

  meta = {
    description = "Taskwarrior-style command line tool for tracking income and expenses";
    license = lib.licenses.gpl3Plus;
    mainProgram = "fca";
    platforms = lib.platforms.unix;
  };
}
