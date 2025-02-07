# Enable Hyprland and enable gpu acceleration
{ options, config, lib, pkgs, inputs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.sound;
in
{

	options.boerg.sound.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		  security.rtkit.enable = true;
          services.pipewire = {
            enable = true; # if not already enabled
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            # If you want to use JACK applications, uncomment this
            jack.enable = true;
          };

          services.pipewire.extraConfig.pipewire."20-pulse-properties.conf" = {
            "pulse.min.req" = "256/48000";
            "pulse.min.frag" = "256/48000";
            "pulse.min.quantum" = "256/48000";
          };
	};
}
