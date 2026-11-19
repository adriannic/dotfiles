local colors = require("colors")
hl.config({
	general = {
		allow_tearing = true,
		gaps_in = 2,
		gaps_out = 4,
		layout = "scrolling",
		no_focus_fallback = true,
		col = {
			active_border = colors.color2,
			inactive_border = "#313244",
			nogroup_border_active = "#ffffaa",
		},
		snap = {
			enabled = true,
			respect_gaps = true,
		},
	},
	decoration = {
		rounding = 0,
		fullscreen_opacity = 0.99999997,
		blur = {
			passes = 3,
			popups = true,
			popups_ignorealpha = 0.3,
			size = 5,
			xray = true,
		},
	},
	input = {
		accel_profile = "flat",
		kb_layout = "es",
		numlock_by_default = true,
		repeat_delay = 300,
		touchpad = {
			natural_scroll = true,
		},
	},
	gestures = {
		workspace_swipe_create_new = false,
		workspace_swipe_distance = 250,
	},
	group = {
		col = {
			border_inactive = "#313244",
			border_active = {
				colors = { "#313244", "#8080c0" },
				angle = 0,
			},
			border_locked_inactive = "#313244",
			border_locked_active = {
				colors = { "#313244", "#8080c0" },
				angle = 0,
			},
		},
		groupbar = {
			gradients = true,
			col = {
				active = {
					colors = { "#313244", "#8080c0" },
					angle = 0,
				},
				inactive = "#313244",
				locked_active = {
					colors = { "#313244", "#8080c0" },
					angle = 0,
				},
				locked_inactive = "#313244",
			},
			blur = true,
		},
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		enable_anr_dialog = false,
		enable_swallow = true,
		exit_window_retains_fullscreen = true,
		focus_on_activate = true,
		force_default_wallpaper = 0,
		key_press_enables_dpms = true,
		middle_click_paste = false,
		mouse_move_enables_dpms = true,
		on_focus_under_fullscreen = 1,
		swallow_regex = "kitty",
		vrr = 1,
	},
	binds = {
		focus_preferred_method = 1,
		movefocus_cycles_fullscreen = true,
	},
	render = {
		cm_auto_hdr = 0,
		direct_scanout = true,
	},
	cursor = {
		hide_on_key_press = true,
		hide_on_tablet = true,
		inactive_timeout = 3,
		no_break_fs_vrr = 0,
		persistent_warps = true,
	},
	ecosystem = {
		enforce_permissions = false,
	},
	dwindle = {
		preserve_split = true,
	},
})
