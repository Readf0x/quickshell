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
      courier = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "Courier";
        version = "1.0";

        src = ./fonts;

        dontBuild = true;

        installPhase = ''
          runHook preInstall
          install -Dm644 --target $out/share/fonts/truetype ./*.ttf
          runHook postInstall
        '';
      });
      neofuturism-config = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "neofuturism-config";
        version = "v1.1";

        src = ./.;

        dontBuild = true;

        installPhase = ''
          mkdir $out
          cp -r src/* $out
        '';
      });
      neofuturism-shell = let
        dependencies = [ pkgs.cava quickshell.packages.${system}.default ];
      in pkgs.writeShellScriptBin "neoshell" ''
        if ! [ $QS_CONFIG_PATH ]; then
          export QS_CONFIG_PATH=${neofuturism-config}
        fi
        export FONTCONFIG_FILE=${pkgs.makeFontsConf { fontDirectories = [ courier ]; }}
        export PATH="${lib.makeBinPath dependencies}:$PATH"
        ${quickshell.packages.${system}.default}/bin/quickshell $@
      '';
      default = neofuturism-shell;
    });
    devShells = perSystem ({ pkgs, system }: {
      default = pkgs.mkShell {
        packages = [
          quickshell.packages.${system}.default
        ];

        QML2_IMPORT_PATH = lib.makeSearchPath "lib/qt-6/qml" [
          "${quickshell.packages.${system}.default}"
          "${pkgs.kdePackages.full}"
        ];

        shellHook = ''
          export QS_CONFIG_PATH="$(pwd)/src"
        '';
      };
    });
  };
}
