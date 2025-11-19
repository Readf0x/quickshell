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
      quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
      qtdeclarative
    ]);
    fontconfig = pkgs: fonts: pkgs.makeFontsConf { fontDirectories = fonts; };
  in {
    packages = perSystem ({ pkgs, system }: rec {
      fonts = pkgs.stdenv.mkDerivation (finalAttrs: rec {
        pname = "bubble-fonts";
        version = "1.0";

        srcs = [
          (pkgs.fetchurl {
            url = "https://github.com/google/fonts/raw/f6e3429503c309ac3a8b77b6178a765b2463f702/ofl/varelaround/VarelaRound-Regular.ttf";
            hash = "sha256-4eR+tm28LdwQZmEzjnEtkXbJ6DxmmoL94VUySCPQOqI=";
          })
          (pkgs.fetchurl {
            url = "https://github.com/google/fonts/raw/f6e3429503c309ac3a8b77b6178a765b2463f702/ofl/cherrybombone/CherryBombOne-Regular.ttf";
            hash = "sha256-lZbGeT6wM1BX1lWxN1HOfMtQ7wzRXLUsWEZfti3iu48=";
          })
        ];

        sourceRoot = ".";
        unpackPhase = ''
          cp ${builtins.elemAt srcs 1} ./CherryBombOne-Regular.ttf
          cp ${builtins.elemAt srcs 0} ./VarelaRound-Regular.ttf
        '';

        dontBuild = true;

        installPhase = ''
          runHook preInstall
          install -Dm644 CherryBombOne-Regular.ttf "$out/share/fonts/truetype/CherryBombOne-Regular.ttf"
          install -Dm644 VarelaRound-Regular.ttf "$out/share/fonts/truetype/VarelaRound-Regular.ttf"
          runHook postInstall
        '';
      });
      bubble-config = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "bubble-config";
        version = "v0.1";

        src = ./src;

        dontBuild = true;

        installPhase = ''
          cp -r . $out
        '';
      });
      bubble-shell = let
        dependencies = [ pkgs.cava pkgs.gowall quickshell.packages.${system}.default ];
      in pkgs.writeShellScriptBin "bubbleshell" ''
        if ! [ $QS_CONFIG_PATH ]; then
          export QS_CONFIG_PATH=${bubble-config}
        fi
        export FONTCONFIG_FILE=${fontconfig pkgs [ fonts ]}
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
          quickshell.packages.${system}.default
        ];

        FONTCONFIG_FILE = fontconfig pkgs [ self.packages.${system}.fonts pkgs.google-fonts ];
        QML2_IMPORT_PATH = qmlPath pkgs;

        shellHook = ''
          export QS_CONFIG_PATH="$(pwd)/src"
        '';
      };
    });
  };
}
