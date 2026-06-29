{
  description = "Nix Dynamic Color Theme for SDDM based on sddm-theme-corners";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs = 
  { self
  , nixpkgs
  , systems
  , ... 
  }:
  let
    version = builtins.substring 0 8 self.lastModifiedDate;
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in
  {
    packages = eachSystem (system: {
      ndct-sddm-corners = nixpkgs.legacyPackages.${system}.callPackage ./nix/package.nix { inherit version; qtVersion = 6; };
      ndct-sddm-corners-qt5 = nixpkgs.legacyPackages.${system}.callPackage ./nix/package.nix { inherit version; qtVersion = 5; };
    });
    defaultPackage = eachSystem (system: self.packages.${system}.ndct-sddm-corners);
  };
}