{
  description = "A very basic flake";

  inputs = {
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  # Optional: Binary cache for the flake
  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };
  outputs = inputs;
}
