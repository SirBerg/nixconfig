{ stdenv
, fetchurl
, lib
, makeWrapper
, dpkg
, autoPatchelfHook
, pkgs
, osquery
,
}:
let
  pname = "vanta";
  version = "1.0.0";
  src = fetchurl {
    url = "https://app.eu.vanta.com/osquery/download/linux";
    name = "vanta-amd64.deb";
    hash = "sha256-u47MuSm2PcfHE3/TVxamnV4gthauIAqJrlGcbS1s9/E=";
  };
in
stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    # binaries + certificate
    mkdir -p $out
    cp -r var $out/

    # systemd service
    mkdir -p $out/lib
    cp -r usr/lib/systemd $out/lib

    # mainProgram
    mkdir -p $out/bin
    cp -r var/vanta/vanta-cli $out/bin/

    runHook postInstall
  '';  
  meta = {
    description = "Vanta security monitoring agent";
    homepage = "https://www.vanta.com";
    maintainers = with lib.maintainers; [ SirBerg ];
    mainProgram = "vanta-cli";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
  };
}
