{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.boerg.co/boerg"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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

    nixpgk-hammering = {
      url = "github:jtojnar/nixpkgs-hammering";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
        url = "github:nix-community/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, ... }:
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
      darwinConf = {pkgs, ...}:{
          imports = [./systems/aarch64-darwin/satou/default.nix];
      };
    in
    lib.mkFlake {
      systems.hosts.meyrin.specialArgs = { inherit (inputs) self; };
      systems.hosts.vmware.specialArgs = { inherit (inputs) self; };
      systems.hosts.izanami.specialArgs = { inherit (inputs) self; };
      systems.hosts.malahayati.specialArgs = { inherit (inputs) self; };
      systems.hosts.nebula.specialArgs = { inherit (inputs) self; };
      systems.hosts.sundance.specialArgs = { inherit (inputs) self; };
      systems.hosts.voluspa.specialArgs = { inherit (inputs) self; };
      systems.hosts.warmind-sundance.specialArgs = { inherit (inputs) self; };
      systems.hosts.warmind-targe.specialArgs = { inherit (inputs) self; };
      systems.hosts.warmind-sagira.specialArgs = { inherit (inputs) self; };
      systems.hosts.warmind-glint.specialArgs = { inherit (inputs) self; };
      systems.hosts.satou.specialArgs = { inherit (inputs) self; };

    darwinConfigurations."satou" = nix-darwin.lib.darwinSystem {
        modules = [ darwinConf ];
    };
      darwinPackages = self.darwinConfigurations."satou".pkgs;

      # To build warmind-sundance use this command:
      # nix build .#systems.hosts.warmind-sundance.config.system.build.qcow-efi
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
      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };

}

