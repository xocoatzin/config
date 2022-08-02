local colors = require("gruvbox-baby.colors").config()
-- dark = "#202020",
-- foreground = "#ebdbb2",
-- background = "#282828",
-- background_dark = "#242424",
-- bg_light = "#32302f",
-- medium_gray = "#504945",
-- comment = "#665c54",
-- gray = "#DEDEDE",
-- soft_yellow = "#EEBD35",
-- soft_green = "#98971a",
-- bright_yellow = "#fabd2f",
-- orange = "#d65d0e",
-- red = "#fb4934",
-- error_red = "#cc241d",
-- magenta = "#b16286",
-- pink = "#D4879C",
-- light_blue = "#7fa2ac",
-- dark_gray = "#83a598",
-- blue_gray = "#458588",
-- forest_green = "#689d6a",
-- clean_green = "#8ec07c",
-- milk = "#E7D7AD",

-- vim.g.gruvbox_baby_background_color = "dark"
vim.g.gruvbox_baby_telescope_theme = 1
-- TODO: Only if set: WEZTERM_UNIX_SOCKET
if os.getenv("TERM_PROGRAM") == "WezTerm" then
	vim.g.gruvbox_baby_transparent_mode = 1
else
	vim.g.gruvbox_baby_transparent_mode = 0
end
vim.g.gruvbox_baby_highlights = {
	-- Visual = { bg = "#444455" },
	Visual = { bg = colors.red },
	Search = { bg = colors.bright_yellow, fg = colors.dark },
	Pmenu = { bg = colors.medium_gray, blend = 0.7 },
	-- DAP
	DapBreakpointLine = { bg = colors.dark },
	DapBreakpoint = { fg = colors.red },
	DapBreakpointCondition = { fg = colors.orange },
	DapBreakpointRejected = { fg = colors.error_red },
	DapLogPoint = { fg = colors.blue_gray },
	DapStopped = { fg = colors.bright_yellow },
	TelescopeBorder = { bg = colors.dark, fg = colors.dark },
	TelescopeNormal = { bg = colors.dark },
	VertSplit = { fg = colors.medium_gray },
	ColorColumn = { bg = colors.medium_gray },
}
vim.cmd([[colorscheme gruvbox-baby]])
