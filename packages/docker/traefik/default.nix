{lib, stdenv}:
stdenv.mkDerivation rec{
    name = "traefik";
    src = ./.;

    installPhase = ''
        mkdir -p $out/bin/
        mkdir -p $out/share/compose/

        cp $src/start.sh $out/bin/
        cp $src/docker-compose.yml $out/share/compose/

    '';
}