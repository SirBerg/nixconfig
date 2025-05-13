{
  nixConfig = {
    extra-substituters = [
	"http://localhost:3000/default"
#	"https://cache.nixos.org"
    ];
    extra-trusted-public-keys = [
	"default:mK6W8AHbTV7DO5VDMDxe0154tNyyaq21eRvP/wwO1UA="
	"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
	];
    trusted-users = [ "root" "berg" ];
	
     substituters = ["http://localhost:3000/default" 
     #"https://cache.nixos.org"
     ];
     always-allow-substitutes = true;
     extra-trusted-substsituters = [
	"http://localhost:3000/default"
#	"https://cache.nixos.org"
	];
     trusted-public-keys = [
	"default:mK6W8AHbTV7DO5VDMDxe0154tNyyaq21eRvP/wwO1UA="
	"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
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
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deadnix = {
      url = "github:astro/deadnix";
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
      systems.hosts.meyrin.specialArgs = { inherit (inputs) self; };
      systems.hosts.vmware.specialArgs = { inherit (inputs) self; };
      systems.hosts.izanami.specialArgs = { inherit (inputs) self; };
      systems.hosts.nebula.specialArgs = { inherit (inputs) self; };
      systems.hosts.voluspa.specialArgs = { inherit (inputs) self; };
      systems.hosts.warmind-sundance.specialArgs = { inherit (inputs) self; };
      systems.hosts.warmind-targe.specialArgs = { inherit (inputs) self; };
      systems.hosts.warmind-sagira.specialArgs = { inherit (inputs) self; };
      systems.hosts.warmind-glint.specialArgs = { inherit (inputs) self; };
      systems.hosts.satou.specialArgs = { inherit (inputs) self; };

      # To build warmind-sundance use this command:
      # nix build .#systems.hosts.warmind-sundance.config.system.build.qcow-efi
      systems.hosts.sundance.modules = with inputs; [
        nixos-generators.nixosModules.qcow-efi
      ];

      systems.modules.nixos = with inputs; [
        Solaar.nixosModules.default
      ];
      systems.hosts.satou.modules = with inputs; [
        nixvim.nixDarwinModules.nixvim
      ];
      home-manager.users.boerg = {
        home.stateVersion = "24.11";
      };
      channels-config = {
        allowUnfree = true;
      };

      overlays = with inputs; [
        hyprpanel.overlay
      ];
      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-darwin = inputs.nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;

      nix.settings.trusted-users = [ "root" "berg" ];
    };

}

