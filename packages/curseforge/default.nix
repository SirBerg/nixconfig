{ appimageTools, fetchurl, lib, makeWrapper }:
let
  pname = "curseforge";
  version = "";
  src = fetchurl {
    url =
      "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.zip";
    hash = "sha256-R9HnkrXeWCQwaoca+C/pddSL9pt5eZXsOpv1uMB6sDY=";
  };
  appImageContents = appimageTools.extract { inherit pname version src; };
in appimageTools.wrapType2 rec {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];
  extraInstallCommands = ''
    install -m 444 -D ${appImageContents}/curseforge.desktop $out/share/applications/curseforge.desktop
    install -m 444 -D ${appImageContents}/curseforge.png \
      $out/share/icons/hicolor/1024x1024/apps/curseforge.png
    substituteInPlace $out/share/applications/curseforge.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=env APPIMAGE=true curseforge'
    wrapProgram $out/bin/curseforge \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';
  meta = {
    description =
      "Curseforge moment";
    homepage = "https://curseforge.com/";
    maintainers = with lib.maintainers; [ SirBerg ];
    mainProgram = "curseforge";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
  };
}
