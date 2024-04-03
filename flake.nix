{
  description = "Nix Dynamic Color Theme for SDDM based on sddm-theme-corners";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs = { self, nixpkgs, ... }:
  let
    version = builtins.substring 0 8 self.lastModifiedDate;
    systemsAttr = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
  in
  {
    packages = systemsAttr (system: {
      ndct-sddm-corners = nixpkgs.legacyPackages.${system}.callPackage ./ndct-sddm-corners.nix { inherit version; };
    });
    defaultPackage = systemsAttr (system: self.packages.${system}.ndct-sddm-corners);
  };
}