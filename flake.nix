{
  description = "Nix Dynamic Color Theme for SDDM based on sddm-theme-corners";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs = { self, nixpkgs, ... }:
  let
    version = builtins.substring 0 8 self.lastModifiedDate;
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in
  {
    packages = eachSystem (system: {
      ndct-sddm-corners = nixpkgs.legacyPackages.${system}.callPackage ./ndct-sddm-corners.nix { inherit version; };
    });
    defaultPackage = eachSystem (system: self.packages.${system}.ndct-sddm-corners);
  };
}