{
  description = "readf0x's quickshell config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, quickshell }: let
    lib = nixpkgs.lib;
    perSystem = package: (lib.listToAttrs (lib.map (a: { name = a; value = package { pkgs = nixpkgs.legacyPackages.${a}; system = a; }; }) (lib.attrNames nixpkgs.legacyPackages)));
    makeQmlPath = pkgs: lib.makeSearchPath "lib/qt-6/qml" (map (path: "${path}") pkgs);
    qmlPath = pkgs: makeQmlPath (with pkgs.kdePackages; [
      quickshell.packages.${pkgs.system}.default
      qtdeclarative
    ]);
  in {
    packages = perSystem ({ pkgs, system }: rec {
      bubble-config = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "bubble-config";
        version = "v0.1";

        src = ./.;

        dontBuild = true;

        installPhase = ''
          mkdir $out
          cp -r src/* $out
        '';
      });
      # export FONTCONFIG_FILE=${pkgs.makeFontsConf { fontDirectories = [  ]; }}
      bubble-shell = let
        dependencies = [ pkgs.cava pkgs.gowall quickshell.packages.${system}.default ];
      in pkgs.writeShellScriptBin "bubbleshell" ''
        if ! [ $QS_CONFIG_PATH ]; then
          export QS_CONFIG_PATH=${bubble-config}
        fi
        export PATH="${lib.makeBinPath dependencies}:$PATH"
        export QML2_IMPORT_PATH="${qmlPath pkgs}"
        ${quickshell.packages.${system}.default}/bin/quickshell $@
      '';
      default = bubble-shell;
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
