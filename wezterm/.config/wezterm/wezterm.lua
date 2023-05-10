local wezterm = require("wezterm")

local bg = function()
	local hue = math.random(180, 220)
	return {
		-- Can be "Vertical" or "Horizontal".  Specifies the direction
		-- in which the color gradient varies.  The default is "Horizontal",
		-- with the gradient going from left-to-right.
		-- Linear and Radial gradients are also supported; see the other
		-- examples below
		orientation = { Linear = { angle = -70.0 } },

		-- Specifies the set of colors that are interpolated in the gradient.
		-- Accepts CSS style color specs, from named colors, through rgb
		-- strings and more
		colors = {
			-- "#32302f",
			"hsl(" .. hue .. ", 15%, 18%)",
			"hsl(" .. hue .. ", 10%, 5%)",
		},

		-- Instead of specifying `colors`, you can use one of a number of
		-- predefined, preset gradients.
		-- A list of presets is shown in a section below.
		-- preset = "Warm",

		-- Specifies the interpolation style to be used.
		-- "Linear", "Basis" and "CatmullRom" as supported.
		-- The default is "Linear".
		interpolation = "Basis",

		-- How the colors are blended in the gradient.
		-- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
		-- The default is "Rgb".
		blend = "Hsv",

		-- To avoid vertical color banding for horizontal gradients, the
		-- gradient position is randomly shifted by up to the `noise` value
		-- for each pixel.
		-- Smaller values, or 0, will make bands more prominent.
		-- The default value is 64 which gives decent looking results
		-- on a retina macbook pro display.
		noise = 100,

		-- By default, the gradient smoothly transitions between the colors.
		-- You can adjust the sharpness by specifying the segment_size and
		-- segment_smoothness parameters.
		-- segment_size configures how many segments are present.
		-- segment_smoothness is how hard the edge is; 0.0 is a hard edge,
		-- 1.0 is a soft edge.

		-- segment_size = 11,
		-- segment_smoothness = 0.0,
	}
end

local window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10. on Windows but 12.0 on other systems
	font_size = 14.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	-- active_titlebar_bg = "#333333",

	-- The overall background color of the tab bar when
	-- the window is not focused
	-- inactive_titlebar_bg = "#333333",
}

local colors = {
	tab_bar = {
		-- The color of the strip that goes along the top of the window
		-- (does not apply when fancy tab bar is in use)
		-- background = "#0b0022",

		-- The active tab is the one that has focus in the window
		active_tab = {
			-- The color of the background area for the tab
			bg_color = "#222222",
			-- The color of the text for the tab
			fg_color = "#c0c0c0",

			-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
			-- label shown for this tab.
			-- The default is "Normal"
			intensity = "Normal",

			-- Specify whether you want "None", "Single" or "Double" underline for
			-- label shown for this tab.
			-- The default is "None"
			underline = "Single",

			-- Specify whether you want the text to be italic (true) or not (false)
			-- for this tab.  The default is false.
			italic = true,

			-- Specify whether you want the text to be rendered with strikethrough (true)
			-- or not for this tab.  The default is false.
			strikethrough = true,
		},

		-- Inactive tabs are the tabs that do not have focus
		-- inactive_tab = {
		-- bg_color = "#1b1032",
		-- fg_color = "#808080",

		-- The same options that were listed under the `active_tab` section above
		-- can also be used for `inactive_tab`.
		-- },

		-- You can configure some alternate styling when the mouse pointer
		-- moves over inactive tabs
		-- inactive_tab_hover = {
		-- bg_color = "#3b3052",
		-- fg_color = "#909090",
		-- italic = true,

		-- The same options that were listed under the `active_tab` section above
		-- can also be used for `inactive_tab_hover`.
		-- },

		-- The new tab button that let you create new tabs
		-- new_tab = {
		-- bg_color = "#1b1032",
		-- fg_color = "#808080",

		-- The same options that were listed under the `active_tab` section above
		-- can also be used for `new_tab`.
		-- },

		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		-- new_tab_hover = {
		-- bg_color = "#3b3052",
		-- fg_color = "#909090",
		-- italic = true,

		-- The same options that were listed under the `active_tab` section above
		-- can also be used for `new_tab_hover`.
		-- },
	},
}

return {
	-- font = wezterm.font("FiraCode Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" }),
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", stretch = "Normal", style = "Normal" }),
	font_size = 14,
	color_scheme = "Gruvbox Dark",
	colors = colors,
	window_frame = window_frame,
	window_background_gradient = bg(),
	window_background_opacity = 0.9,
	macos_window_background_blur = 1000,
	default_prog = { "/usr/local/bin/fish", "-l" },
	use_dead_keys = false,
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.8,
	},
	scrollback_lines = 15000,
	initial_rows = 80,
	initial_cols = 200,
	-- default_cursor_style = 'BlinkingBlock',
	-- cursor_blink_rate = 500,
	-- cursor_blink_ease_in = "EaseInOut",
	-- cursor_blink_ease_out = "EaseInOut",
}
