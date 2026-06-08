-- Monitor and workspace-to-monitor assignments

-- Built-in laptop display
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080",
	position = "0x0",
	scale = "1",
})

-- External display, rotated 90° (portrait)
hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080",
	position = "1920x0",
	scale = "1",
	-- transform = 1,
})

-- Fallback for any other monitor
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-- Workspaces 1-6 on laptop, 7-10 on external
for i = 1, 6 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end
for i = 7, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end
