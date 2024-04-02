{ nixpkgs ? import <nixpkgs> {}, ... }:

nixpkgs.callPackage ./ndct-sddm-corners.nix { version = "unknown"; }