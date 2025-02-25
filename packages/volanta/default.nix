{appimageTools, fetchurl, lib}:
let
    pname = "volanta";
    version = "1.10.10";
    description = "Volanta is an easy-to-use smart flight tracker that integrates all your flight data across all major sims.";
    src = builtins.fetchurl {
        url = "https://cdn.volanta.app/software/volanta-app/1.10.10-a7ebf1c7/volanta-1.10.10.AppImage";
        sha256 = "a5d30f0b77e527382e458992fb12a2017590e012ac0f7378f12dbb7635c3b6ea";
    };
    appImageContents = appimageTools.extractType1 { inherit pname version src; };
in
appimageTools.wrapType2 rec{
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appImageContents}/volanta.desktop $out/share/applications/volanta.desktop
    install -m 444 -D ${appImageContents}/volanta.png \
          $out/share/icons/hicolor/512x512/apps/volanta.png
    substituteInPlace $out/share/applications/volanta.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=env APPIMAGE=true ${pname}'
  '';
    meta = {
        description = "${description}";
        homepage = "https://volanta.app/";
        maintainers = with lib.maintainers; [ SirBerg ];
        platforms = [ "x86_64-linux" ];
    };
}