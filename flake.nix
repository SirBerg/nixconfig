{
    nixConfig = {
        extra-substituters = [
            # Community cache
            "https://nix-community.cachix.org"
            "https://attic.holypenguin.net/holynix"
            #Own cache
            "https://cache.boerg.co/boerg"
            #Own cache internal
            #"https://attic.naibu.boerg.co/boerg"
        ];
        extra-trusted-public-keys = [
            # nix community's cache server public key
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

            "holynix:Ucr2JJ5xLEy4hElI/SToX5klNe4I3wKgVIa2+b3lmYo="

            "boerg:YGQg7krTwrl7UO77lLoWevtV5Cq9F4pubjoGmDEoqo0="
        ];
    };
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        #ags.url = "github:Aylur/ags";
        hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
        Solaar.url = "github:Svenum/Solaar-Flake";
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
        nixos-generators = {
          url = "github:nix-community/nixos-generators";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs:
    let
        lib = inputs.snowfall-lib.mkLib {
            # You must provide our flake inputs to Snowfall Lib.
            inherit inputs;
		#homes.modules = with inputs; [
	    #		ags.homeManagerModules.default
		#];
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
        };
    in
        lib.mkFlake {
            systems.hosts.meyrin.specialArgs = {inherit (inputs) self;};
            systems.hosts.vmware.specialArgs = {inherit (inputs) self;};
            systems.hosts.izanami.specialArgs =  {inherit (inputs) self;};
            systems.hosts.malahayati.specialArgs = {inherit (inputs) self;};
            systems.hosts.nebula.specialArgs = {inherit (inputs) self;};
            systems.hosts.sundance.specialArgs = {inherit (inputs) self;};

            # To build sundance use this command:
            # nix build .#systems.hosts.sundance.config.system.build.qcow-efi
            systems.hosts.sundance.modules = with inputs; [
                nixos-generators.nixosModules.qcow-efi
            ];

            systems.modules.nixos = with inputs; [
                Solaar.nixosModules.default
            ];

            channels-config = {
            allowUnfree = true;
            };

            overlays = with inputs; [
                hyprpanel.overlay
            ];
    };
}

