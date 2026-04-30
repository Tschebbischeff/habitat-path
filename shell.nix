{ pkgs ? import <nixpkgs> {}}:

with pkgs;
mkShell {
  packages = [
    python3
    python3Packages.pip
  ];
  shellHook = ''
    python -m venv .venv
    source .venv/bin/activate
  '';
}