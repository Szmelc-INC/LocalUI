{
  description = "Tiny PHP/JS local web UI that renders controls from JSON config and drives the OS via shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: rec {
        localui = pkgs.stdenvNoCC.mkDerivation {
          pname = "localui";
          version = "0.2.0-unstable-${self.shortRev or self.dirtyShortRev or "dirty"}";
          src = ./.;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          dontBuild = true;
          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/localui
            cp -r api lib public browser config $out/share/localui/
            install -Dm755 bin/localui $out/bin/localui
            patchShebangs $out/bin $out/share/localui/browser
            wrapProgram $out/bin/localui --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.php pkgs.xdg-utils ]}
            install -Dm644 README.md -t $out/share/doc/localui
            runHook postInstall
          '';
          meta = {
            description = "Tiny PHP/JS local web UI that renders controls from JSON config and drives the OS via shell";
            homepage = "https://github.com/Szmelc-INC/LocalUI";
            license = pkgs.lib.licenses.mit;
            mainProgram = "localui";
            platforms = pkgs.lib.platforms.unix;
          };
        };
        default = localui;
      });

      apps = forAllSystems (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/localui";
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell { packages = with pkgs; [ php xdg-utils shellcheck ]; };
      });
    };
}
