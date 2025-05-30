# Neofuturism Quickshell config

![screenshot](./example.png)

## Installation on NixOS

Add the following to your inputs:

```nix
neoshell = {
  url = "github:readf0x/quickshell";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

The package is available as `default`, if installed it provides a wrapper script called `neoshell` that can be controlled the exact same way as quickshell.

## Installation on other distros

1. Copy the `src` directory to `~/.config/quickshell`
2. Copy the contents of the `fonts` directory into `~/.local/share/fonts`

