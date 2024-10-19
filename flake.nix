{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	ags.url = "github:Aylur/ags";
	hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};
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
		homes.modules = with inputs; [
	    		ags.homeManagerModules.default
		];

	    
            # The `src` must be the root of the flake. See configuration
            # in the next section for information on how you can move your
            # Nix files to a separate directory.
            src = ./.;
            snowfall = {
                namespace = "boerg";
                meta = {
                        name = "boerg";
                        title = "Boerg";
                };
            };
	    channels-config = {
		allowUnfree = true;
	    };

	    overlays = with inputs; [
		hyprpanel.overlay
	    ];
        };
}

