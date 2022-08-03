return require("packer").startup(function()
	use({ "wbthomason/packer.nvim" })
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
		},
		run = ":TSUpdate",
	})
	use({ "numToStr/Comment.nvim" })
	use({ "akinsho/nvim-bufferline.lua" })
	use({ "lukas-reineke/indent-blankline.nvim" })
	use({ "luukvbaal/stabilize.nvim" })
	use({
		"glepnir/galaxyline.nvim",
		branch = "main",
		requires = {
			"kyazdani42/nvim-web-devicons",
			opt = true,
		},
	})
	use({ "romgrk/nvim-treesitter-context" })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "tami5/sqlite.lua" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-github.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "nvim-telescope/telescope-file-browser.nvim" },
			{ "nvim-telescope/telescope-frecency.nvim" },
			{ "nvim-telescope/telescope-dap.nvim" },
		},
	})
	use({ "folke/which-key.nvim" })
	use({ "luisiacc/gruvbox-baby" })
	use({ "norcalli/nvim-colorizer.lua" })
	use({ "lewis6991/gitsigns.nvim" })
	use({ "karb94/neoscroll.nvim" })
	use({ "windwp/nvim-autopairs" })
	use({
		"L3MON4D3/LuaSnip",
		after = "nvim-cmp",
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-calc" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-emoji" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "f3fora/cmp-spell" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
	})
	use({
		"neovim/nvim-lspconfig",
		requires = {
			{ "williamboman/nvim-lsp-installer" },
			{ "creativenull/diagnosticls-configs-nvim" },
			-- { "jose-elias-alvarez/null-ls.nvim" },
		},
	})
	use({
		"mfussenegger/nvim-dap",
		requires = {
			{ "mfussenegger/nvim-dap-python" },
			{ "theHamsta/nvim-dap-virtual-text" },
			{ "rcarriga/nvim-dap-ui" },
		},
	})
	use({ "simrat39/rust-tools.nvim" })

	-- use({ "ggandor/lightspeed.nvim" })
	use({ "andythigpen/nvim-coverage" })
	use({ "ggandor/leap.nvim" })
	use({ "kylechui/nvim-surround" })
	use({ "lewis6991/spellsitter.nvim" })
	use({ "rcarriga/nvim-notify" })
	use({ "lewis6991/impatient.nvim" })

	-- Vimscript plugins
	-- use({ "flazz/vim-colorschemes" })
	use({ "flwyd/vim-conjoin" })
	use({ "github/copilot.vim", disable = true })
	use({ "junegunn/vim-easy-align" })
	-- use({ "machakann/vim-sandwich" })
	use({ "nelstrom/vim-visual-star-search" })
	use({ "qpkorr/vim-bufkill" })
	use({ "scrooloose/nerdtree" })
	use({ "tiagofumo/vim-nerdtree-syntax-highlight" })
	use({ "tpope/vim-abolish" })
	use({ "tpope/vim-fugitive" })
	use({ "tpope/vim-sleuth" })

	-- use 'SirVer/ultisnips'
	-- use 'honza/vim-snippets'
	-- use 'tmhedberg/SimpylFold'
end)
