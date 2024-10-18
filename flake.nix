{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        # The name "snowfall-lib" is required due to how Snowfall Lib processes your
        # flake's inputs.
        snowfall-lib = {
            url = "github:snowfallorg/lib";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    # We will handle this in the next section.
    outputs = inputs:
        inputs.snowfall-lib.mkFlake {
            # You must provide our flake inputs to Snowfall Lib.
            inherit inputs;

            # The `src` must be the root of the flake. See configuration
            # in the next section for information on how you can move your
            # Nix files to a separate directory.
            src = ./.;
            snowfall = {
                namespace = "boerg.co";
                meta = {
                        name = "boerg";
                        title = "Boerg";
                };
            };
        };
}

