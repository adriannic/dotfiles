local colors = require("colors")
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		["col.inactive_border"] = "#313244",
		["col.active_border"] = colors.color2,
		["col.nogroup_border_active"] = "#ffffaa",
		no_focus_fallback = true,
		allow_tearing = true,
		snap = {
			enabled = true,
		},
	},
	decoration = {
		rounding = 0,
		fullscreen_opacity = 0.99999997,
		blur = {
			size = 5,
			passes = 3,
			popups = true,
		},
	},
	input = {
		kb_layout = "es",
		repeat_delay = 300,
		accel_profile = "flat",
		scroll_method = "2fg",
		follow_mouse = 1,
		touchpad = {
			natural_scroll = true,
			scroll_factor = 1.0,
			tap_to_click = true,
		},
		touchdevice = {
			transform = 0,
		},
		tablet = {
			transform = 0,
		},
	},
	gestures = {
		workspace_swipe_distance = 250,
		workspace_swipe_create_new = false,
	},
	group = {
		["col.border_inactive"] = "#313244",
		["col.border_active"] = { colors = { "#313244", "#8080c0" }, angle = 0 },
		["col.border_locked_inactive"] = "#313244",
		["col.border_locked_active"] = { colors = { "#313244", "#8080c0" }, angle = 0 },
		groupbar = {
			gradients = true,
			["col.active"] = { colors = { "#313244", "#8080c0" }, angle = 0 },
			["col.inactive"] = "#313244",
			["col.locked_active"] = { colors = { "#313244", "#8080c0" }, angle = 0 },
			["col.locked_inactive"] = "#313244",
			blur = true,
		},
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		vrr = 1,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		enable_swallow = true,
		swallow_regex = "kitty",
		background_color = 0x000,
		on_focus_under_fullscreen = 1,
		exit_window_retains_fullscreen = true,
	},
	binds = {
		focus_preferred_method = 1,
		movefocus_cycles_fullscreen = true,
	},
	render = {
		direct_scanout = true,
	},
	cursor = {
		inactive_timeout = 3,
		persistent_warps = true,
		hide_on_key_press = true,
	},
	ecosystem = {
		enforce_permissions = false,
	},
	dwindle = {
		preserve_split = true,
	},
})
