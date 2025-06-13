{
  description = "readf0x's quickshell config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, quickshell }: let
    lib = nixpkgs.lib;
    perSystem = package: (lib.listToAttrs (lib.map (a: { name = a; value = package { pkgs = nixpkgs.legacyPackages.${a}; system = a; }; }) (lib.attrNames nixpkgs.legacyPackages)));
    makeQmlPath = pkgs: lib.makeSearchPath "lib/qt-6/qml" (map (path: "${path}") pkgs);
    qmlPath = pkgs: makeQmlPath [
      quickshell.packages.${pkgs.system}.default
      pkgs.kdePackages.full
    ];
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
        dependencies = [ pkgs.cava pkgs.gowall quickshell.packages.${system}.default ];
      in pkgs.writeShellScriptBin "neoshell" ''
        if ! [ $QS_CONFIG_PATH ]; then
          export QS_CONFIG_PATH=${neofuturism-config}
        fi
        export FONTCONFIG_FILE=${pkgs.makeFontsConf { fontDirectories = [ courier ]; }}
        export PATH="${lib.makeBinPath dependencies}:$PATH"
        export QML2_IMPORT_PATH="${qmlPath pkgs}"
        ${quickshell.packages.${system}.default}/bin/quickshell $@
      '';
      default = neofuturism-shell;
    });
    devShells = perSystem ({ pkgs, system }: {
      default = pkgs.mkShell {
        packages = [
          pkgs.cava
          pkgs.gowall
          self.packages.${system}.default
        ];

        QML2_IMPORT_PATH = qmlPath pkgs;

        shellHook = ''
          export QS_CONFIG_PATH="$(pwd)/src"
        '';
      };
    });
  };
}
