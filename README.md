# NDCT

Nix Dynamic Color Theme for [SDDM](https://github.com/sddm/sddm) that is inspired by [corners](https://github.com/aczw/sddm-theme-corners).

Thanks for developers of [lutgen-rs](https://github.com/ozwaldorf/lutgen-rs).

<img src="assets/sample1.png" width="45%"></img>

## Installation

Package is meant to be installed only on NixOS, otherwise just install [original package](https://github.com/aczw/sddm-theme-corners)

### NixOS

Just add this flake as an input and reference its package output for installation. Then use it within your config by name for sddm theme.

```nix
inputs.ndct-sddm.url = "github:id3v1669/ndct-sddm-corners";
inputs.ndct-sddm.inputs.nixpkgs.follows = "nixpkgs";

...

inputs.ndct-sddm.packages.${pkgs.hostPlatform.system}.ndct-sddm-corners

...

services.xserver = {
    enable = true;

    libinput.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        extraPackages = with pkgs; [
          libsForQt5.qt5.qtgraphicaleffects
        ];
        theme = "ndct";
      };
    };
  };

```

## Configuration

To edit colors, use 'override'
```nix

inputs.ndct-sddm.packages.${pkgs.hostPlatform.system}.ndct-sddm-corners.override {
  base00 = "000000";
  base01 = "0000AA";

  ...

}

```

## License

This project is licensed under GPLv3. Check it out [here](LICENSE).

## Thanks!

That's pretty much it :) I hope you enjoy the theme. Feedback is much appreciated!!
