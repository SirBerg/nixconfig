{ stdenv
, fetchurl
, lib
, makeWrapper
, dpkg
, autoPatchelfHook
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
	makeWrapper
  ];

  unpackPhase = ''
  	runHook preUnpack
	dpkg-deb -x "$src" pkg
	runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall

    # Copy all agent binaries and assets to libexec
    mkdir -p "$out/libexec/vanta" "$out/bin"
    cp -r pkg/var/vanta/* "$out/libexec/vanta/"
    chmod +x \
      "$out/libexec/vanta/vanta-cli" \
      "$out/libexec/vanta/launcher" \
      "$out/libexec/vanta/metalauncher" \
      "$out/libexec/vanta/osqueryd" \
      "$out/libexec/vanta/osquery-vanta.ext"

    # Expose vanta-cli on PATH
    makeWrapper "$out/libexec/vanta/vanta-cli" "$out/bin/vanta-cli"

    runHook postInstall
  '';
  meta = {
    description = "Vanta security monitoring agent";
    homepage = "https://www.vanta.com";
    maintainers = with lib.maintainers; [ SirBerg ];
    mainProgram = "vanta";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
  };
}
