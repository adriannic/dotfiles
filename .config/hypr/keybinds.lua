local mainMod = "SUPER"

hl.bind(
	mainMod .. " + SHIFT + L",
	hl.dsp.exec_cmd(
		"bash -c 'mpv --no-video ~/.config/audio/sonic/pause.wav' & hyprlock; bash -c 'mpv --no-video ~/.config/audio/sonic/confirm.wav'"
	)
)
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("fish -c 'wp $(cat ~/.cache/wallpaper/selected)'"))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("killall wofi || cliphist list | wofi -S dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("killall wofi || wofi"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("F11", hl.dsp.window.fullscreen())
hl.bind(
	" + CTRL + ALT + A",
	hl.dsp.exec_cmd("pkill -f ~/.config/hypr/scripts/autoclicker.sh || bash ~/.config/hypr/scripts/autoclicker.sh")
)
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("swayosd-client --brightness=lower"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("swayosd-client --brightness=raise"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- switches
hl.bind("switch:off:Lid", hl.dsp.exec_cmd("bash ~/.config/swaylock/pywal.sh"), { locked = true })

-- move focus with mainMod + arrow keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

-- mwitch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "1", on_current_monitor = true }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2", on_current_monitor = true }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "3", on_current_monitor = true }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = "4", on_current_monitor = true }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = "5", on_current_monitor = true }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = "6", on_current_monitor = true }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = "7", on_current_monitor = true }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = "8", on_current_monitor = true }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = "9", on_current_monitor = true }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10", on_current_monitor = true }))

-- move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
