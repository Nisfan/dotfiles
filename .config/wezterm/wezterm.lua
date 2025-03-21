-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- This is where you actually apply your config choices
--
config.font_size = 15.0
-- config.enable_tab_bar = false
-- config.window_background_opacity = 0.94
config.term = "xterm-256color"

-- For example, changing the color scheme:
config.color_scheme = "catppuccin-mocha"

-- config.font = wezterm.font("Iosevka")
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = true

config.leader = { key = "n", mods = "CTRL", timeout_milliseconds = 2000 }

local action = wezterm.action

config.keys = {
	{ key = "a", mods = "LEADER|CTRL", action = action({ SendString = "\x01" }) },
	{ key = '"', mods = "LEADER", action = action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "%", mods = "LEADER", action = action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "o", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = action({ ActivatePaneDirection = "Right" }) },
	{ key = "H", mods = "LEADER|SHIFT", action = action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER|SHIFT", action = action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER|SHIFT", action = action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER|SHIFT", action = action({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "0", mods = "LEADER", action = action({ ActivateTab = 0 }) },
	{ key = "1", mods = "LEADER", action = action({ ActivateTab = 1 }) },
	{ key = "2", mods = "LEADER", action = action({ ActivateTab = 2 }) },
	{ key = "3", mods = "LEADER", action = action({ ActivateTab = 3 }) },
	{ key = "4", mods = "LEADER", action = action({ ActivateTab = 4 }) },
	{ key = "5", mods = "LEADER", action = action({ ActivateTab = 5 }) },
	{ key = "6", mods = "LEADER", action = action({ ActivateTab = 6 }) },
	{ key = "7", mods = "LEADER", action = action({ ActivateTab = 7 }) },
	{ key = "8", mods = "LEADER", action = action({ ActivateTab = 8 }) },
	{ key = "&", mods = "LEADER|SHIFT", action = action({ CloseCurrentTab = { confirm = true } }) },
	{ key = "d", mods = "LEADER", action = action({ CloseCurrentPane = { confirm = true } }) },
	{ key = "x", mods = "LEADER", action = action({ CloseCurrentPane = { confirm = true } }) },
}

return config
