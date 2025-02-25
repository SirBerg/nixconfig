{appimageTools, fetchurl, lib}:
let
    pname = "volanta";
    version = "1.10.10";
    description = "Volanta is a desktop application that lets you track your flightsimming flights in real-time.";
    src = builtins.fetchurl {
        url = "https://cdn.volanta.app/software/volanta-app/1.10.10-a7ebf1c7/volanta-1.10.10.AppImage";
        sha256 = "a5d30f0b77e527382e458992fb12a2017590e012ac0f7378f12dbb7635c3b6ea";
    };
in
appimageTools.wrapType2{
    inherit pname version src;
    extraPkgs = pkgs: [pkgs.at-spi2-core ];
}