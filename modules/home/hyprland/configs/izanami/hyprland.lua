hl.monitor({
	output = "DP-1",
	mode = "2560x1440@164.95799",
	position = "2560x0",
	scale = 1
})
hl.monitor({
	output = "DP-2",
	mode = "3840x2160@60.00",
	position = "0x0",
	scale = 1.5
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "2560x1440@60.00",
	position = "5120x0",
	scale = 1
})
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1
})

hl.workspace_rule({
	monitor = "DP-1",
	workspace = "1"
})

hl.workspace_rule({
	monitor = "DP-2",
	workspace = "2"
})

hl.workspace_rule({
	monitor = "HDMI-A-1",
		workspace = "3"
})

hl.workspace_rule({
	monitor = "HEADLESS-1",
	workspace = 9
})

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

hl.env("XCURSOR_SIZE", "24")

hl.config({
	input = {
		kb_layout = "de",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		touchpad = {
			natural_scroll = false
		},
		sensitivity = 0
	},
	general = {
		gaps_in = 2,
		gaps_out = 8,
		border_size = 2,
		col = {
			active_border = {colors = {"rgba(204, 36, 29, 0.5)", "rgba(215, 153, 33, 0.5)"}, deg=45},
			inactive_border = "rgba(696969aa)"
		},
		layout = "dwindle",
		resize_on_border = true
	},
	decoration = {
		rounding = 5,
		blur = {
			enabled = true,
			size = 3,
			passes = 1
		}
	},
	animations = {
		enabled = true
	},
	dwindle = {
		preserve_split = true
	}
})

hl.bind("ALT + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind("ALT + F", hl.dsp.exec_cmd("firefox"))
hl.bind("ALT + WIN + F", hl.dsp.window.fullscreen({action = "toggle"}))
hl.bind("ALT + Q", hl.dsp.window.close())
hl.bind("ALT + M", hl.dsp.exit())
hl.bind("ALT + E", hl.dsp.exec_cmd("dolphin"))
hl.bind("ALT + V", hl.dsp.window.float({action = "toggle"}))
hl.bind("ALT + WIN + P", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("ALT + D", hl.dsp.exec_cmd("wofi --show drun"))

hl.bind("WIN + L", hl.dsp.exec_cmd("swaylock"))

hl.bind("ALT + SHIFT + H", hl.dsp.window.swap({direction = "l"}))
hl.bind("ALT + SHIFT + L", hl.dsp.window.swap({direction = "r"}))
hl.bind("ALT + SHIFT + J", hl.dsp.window.swap({direction = "d"}))
hl.bind("ALT + SHIFT + K", hl.dsp.window.swap({direction = "u"}))

hl.bind("ALT + TAB", hl.dsp.window.cycle_next())

hl.bind("ALT + H", hl.dsp.focus({direction = "l"}))
hl.bind("ALT + L", hl.dsp.focus({direction = "r"}))
hl.bind("ALT + K", hl.dsp.focus({direction = "u"}))
hl.bind("ALT + J", hl.dsp.focus({direction = "d"}))

hl.bind("ALT + 1", hl.dsp.focus({workspace = 1}))
hl.bind("ALT + 2", hl.dsp.focus({workspace = 2}))
hl.bind("ALT + 3", hl.dsp.focus({workspace = 3}))
hl.bind("ALT + 4", hl.dsp.focus({workspace = 4}))
hl.bind("ALT + 5", hl.dsp.focus({workspace = 5}))
hl.bind("ALT + 6", hl.dsp.focus({workspace = 6}))
hl.bind("ALT + 7", hl.dsp.focus({workspace = 7}))
hl.bind("ALT + 8", hl.dsp.focus({workspace = 8}))
hl.bind("ALT + 9", hl.dsp.focus({workspace = 9}))
hl.bind("ALT + 0", hl.dsp.focus({workspace = 10}))

hl.bind("ALT + SHIFT + 1", hl.dsp.window.move({workspace = 1}))
hl.bind("ALT + SHIFT + 2", hl.dsp.window.move({workspace = 2}))
hl.bind("ALT + SHIFT + 3", hl.dsp.window.move({workspace = 3}))
hl.bind("ALT + SHIFT + 4", hl.dsp.window.move({workspace = 4}))
hl.bind("ALT + SHIFT + 5", hl.dsp.window.move({workspace = 5}))
hl.bind("ALT + SHIFT + 6", hl.dsp.window.move({workspace = 6}))
hl.bind("ALT + SHIFT + 7", hl.dsp.window.move({workspace = 7}))
hl.bind("ALT + SHIFT + 8", hl.dsp.window.move({workspace = 8}))
hl.bind("ALT + SHIFT + 9", hl.dsp.window.move({workspace = 9}))
hl.bind("ALT + SHIFT + 0", hl.dsp.window.move({workspace = 10}))

-- Switch to a submap called `resize`.
hl.bind("ALT + R", hl.dsp.submap("resize"))
-- Start a submap called "resize".
hl.define_submap("resize", function()

    -- Set repeating binds for resizing the active window.
    hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true}), { repeating = true })
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true}), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = 10, relative = true}), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = -10, relative = true}), { repeating = true })

    -- Use `reset` to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
end)

hl.curve("myBezier", {type = "bezier", points = {{0.05, 0.9}, {0.1, 1.05}}})
hl.animation({
	leaf = "windows", enabled = true, speed = 2.5, bezier = "myBezier", style = "gnomed"
})
hl.animation({
	leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "myBezier", style = "poping 80%"
})
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })

hl.animation({
	leaf = "fade", enabled = true, speed = 5, bezier = "myBezier" 
})
hl.animation({
	leaf = "workspaces", enabled = true, speed = 1, bezier = "myBezier"
})

hl.env("SSH_AUTH_SOCK", "$HOME/.ssh/agent.sock")
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	hl.exec_cmd("wayle panel start")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("xauth -f ~/.Xauthority add :0 MIT-MAGIC-COOKIE-1 $(mcookie)")
end)
