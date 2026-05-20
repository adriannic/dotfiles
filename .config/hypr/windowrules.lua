-- tearing
hl.window_rule({ match = { workspace = 3 }, content = "game" })
hl.window_rule({ match = { content = 3 }, immediate = true })

-- yad
hl.window_rule({ match = { initial_class = "^(yad)$" }, center = true })

-- polkit
hl.window_rule({ match = { class = "^(polkit-gnome-authentication-agent-1)$" }, float = true, dim_around = true })

-- wofi
hl.window_rule({ match = { class = "^(wofi)$" }, border_size = 0, no_shadow = true })

-- steam
hl.window_rule({ match = { class = "^([Ss]team)$", title = "^(([Ss]team).*)$" }, float = true })
hl.window_rule({ match = { class = "^([Ss]team)$", title = "^([Ss]team)$" }, tile = true, workspace = "3 silent" })

-- workspaces
hl.window_rule({ match = { class = "^([Ss]team|osu!)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(firefox|brave-browser)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, workspace = "5" })
hl.window_rule({ match = { class = "^(discord|vesktop)$" }, workspace = "6" })
hl.window_rule({ match = { class = "^(whatsdesk)$" }, workspace = "7" })
hl.window_rule({ match = { class = "^(Spotify|com.github.th_ch.youtube_music)$" }, workspace = "8" })
hl.window_rule({ match = { class = "^(com.obsproject.Studio)$" }, workspace = "9" })

-- suppress maximize events
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- fix xwayland drags
hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
