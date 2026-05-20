hl.layer_rule({
	match = { namespace = "quickshell" },
	blur = true,
	ignore_alpha = false,
	blur_popups = true,
})
hl.layer_rule({
	match = { namespace = "gtk4-layer-shell" },
	blur = true,
	ignore_alpha = false,
	blur_popups = true,
})
hl.layer_rule({
	match = { namespace = "wofi" },
	blur = true,
	ignore_alpha = false,
	blur_popups = true,
})
hl.layer_rule({
	match = { namespace = "swayosd" },
	blur = true,
	ignore_alpha = false,
	blur_popups = true,
})
hl.layer_rule({ match = { namespace = "^(quickshell)$" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^(gtk4-layer-shell)$" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^(mpvpaper)$" }, no_anim = true })
hl.layer_rule({ match = { namespace = "^(selection)$" }, no_anim = true })
