hl.curve("easeOutQuart", {
	type = "bezier",
	points = { { 0.25, 1 }, { 0.5, 1 } },
})

hl.curve("easeInOutQuart", {
	type = "bezier",
	points = { { 0.76, 0 }, { 0.24, 1 } },
})

hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 3,
	bezier = "easeOutQuart",
	style = "slide",
})

hl.animation({
	leaf = "layers",
	enabled = true,
	speed = 3,
	bezier = "easeOutQuart",
	style = "slide",
})

hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 3,
	bezier = "easeOutQuart",
})

hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 3,
	bezier = "easeInOutQuart",
	style = "slide",
})
