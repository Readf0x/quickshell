{
  description = "readf0x's quickshell config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, quickshell }: let
    lib = nixpkgs.lib;
    perSystem = package: (lib.listToAttrs (lib.map (a: { name = a; value = package { pkgs = nixpkgs.legacyPackages.${a}; system = a; }; }) (lib.attrNames nixpkgs.legacyPackages)));
  in {
    packages = perSystem ({ pkgs, system }: rec {
      neofuturism-config = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "neofuturism-config";
        version = "v1.0";

        src = ./.;

        dontBuild = true;

        installPhase = ''
          mkdir $out
          cp -r img $out
          cp -r scripts $out
          cp *.qml $out
          cp cava.conf $out
        '';
      });
      neofuturism-shell = pkgs.writeShellScriptBin "neoshell" ''
        export QS_CONFIG_PATH=${neofuturism-config}
        ${quickshell.packages.${system}.default}/bin/quickshell $@
      '';
      default = neofuturism-shell;
    });
  };
}
