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

if vim.g.neovide then
	vim.g.gruvbox_baby_transparent_mode = 0
end

vim.g.gruvbox_baby_highlights = {
	Visual = { bg = "#444455" },
	Search = { bg = colors.bright_yellow, fg = colors.dark },
	Pmenu = { bg = colors.medium_gray, blend = 0.7 },
	VertSplit = { fg = colors.medium_gray },
	ColorColumn = { bg = colors.medium_gray },
	FoldColumn = { fg = colors.comment },

	-- Telescope
	TelescopeBorder = { bg = colors.dark, fg = colors.dark },
	TelescopeNormal = { bg = colors.dark },

	-- NvimTree
	NvimTreeWinSeparator = { bg = colors.dark, fg = colors.dark },
	NvimTreeNormal = { bg = colors.dark },
	NvimTreeNormalNC = { bg = colors.dark },

	-- LSP
	LspReferenceRead = { bg = colors.medium_gray, style = "bold" },
	LspReferenceText = { bg = colors.medium_gray, style = "bold" },
	LspReferenceWrite = { bg = colors.medium_gray, style = "bold" },
	-- Flaot Window
	FloatBorder = { bg = colors.dark, fg = colors.medium_gray },
	NormalFloat = { bg = colors.dark },
	-- DAP
	DapBreakpointLine = { bg = colors.dark },
	DapBreakpoint = { fg = colors.red },
	DapBreakpointCondition = { fg = colors.orange },
	DapBreakpointRejected = { fg = colors.error_red },
	DapLogPoint = { fg = colors.blue_gray },
	DapStopped = { fg = colors.bright_yellow },
	-- Notify
	-- NotifyDEBUGBody = { bg = colors.dark },
	-- NotifyDEBUGBorder = { bg = colors.dark },
	-- NotifyDEBUGIcon = { bg = colors.dark },
	-- NotifyDEBUGTitle = { bg = colors.dark },
	-- NotifyERRORBody = { bg = colors.dark },
	-- NotifyERRORBorder = { bg = colors.dark },
	-- NotifyERRORIcon = { bg = colors.dark },
	-- NotifyERRORTitle = { bg = colors.dark },
	-- NotifyINFOBody = { bg = colors.dark },
	-- NotifyINFOBorder = { bg = colors.dark },
	-- NotifyINFOIcon = { bg = colors.dark },
	-- NotifyINFOTitle = { bg = colors.dark },
	-- NotifyTRACEBody = { bg = colors.dark },
	-- NotifyTRACEBorder = { bg = colors.dark },
	-- NotifyTRACEIcon = { bg = colors.dark },
	-- NotifyTRACETitle = { bg = colors.dark },
	-- NotifyWARNBody = { bg = colors.dark },
	-- NotifyWARNBorder = { bg = colors.dark },
	-- NotifyWARNIcon = { bg = colors.dark },
	-- NotifyWARNTitle = { bg = colors.dark },
	--
	-- NotifyDEBUGBody = { fg = colors.foreground, bg = colors.medium_gray },
	-- NotifyDEBUGBorder = { fg = colors.medium_gray, bg = colors.medium_gray },
	-- NotifyDEBUGIcon = { fg = colors.foreground, bg = colors.medium_gray },
	-- NotifyDEBUGTitle = { fg = colors.foreground, bg = colors.medium_gray },
	-- NotifyERRORBody = { fg = colors.foreground, bg = colors.error_red },
	-- NotifyERRORBorder = { fg = colors.error_red, bg = colors.error_red },
	-- NotifyERRORIcon = { fg = colors.foreground, bg = colors.error_red },
	-- NotifyERRORTitle = { fg = colors.foreground, bg = colors.error_red },
	-- NotifyINFOBody = { fg = colors.foreground, bg = colors.blue_gray },
	-- NotifyINFOBorder = { fg = colors.blue_gray, bg = colors.blue_gray },
	-- NotifyINFOIcon = { fg = colors.foreground, bg = colors.blue_gray },
	-- NotifyINFOTitle = { fg = colors.foreground, bg = colors.blue_gray },
	-- NotifyTRACEBody = { fg = colors.foreground, bg = colors.magenta },
	-- NotifyTRACEBorder = { fg = colors.magenta, bg = colors.magenta },
	-- NotifyTRACEIcon = { fg = colors.foreground, bg = colors.magenta },
	-- NotifyTRACETitle = { fg = colors.foreground, bg = colors.magenta },
	-- NotifyWARNBody = { fg = colors.dark, bg = colors.bright_yellow },
	-- NotifyWARNBorder = { fg = colors.bright_yellow, bg = colors.bright_yellow },
	-- NotifyWARNIcon = { fg = colors.dark, bg = colors.bright_yellow },
	-- NotifyWARNTitle = { fg = colors.dark, bg = colors.bright_yellow },
}
vim.cmd([[colorscheme gruvbox-baby]])
