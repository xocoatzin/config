local gl = require("galaxyline")
local gls = gl.section
gl.short_line_list = {
    'term',
    'nerdtree',
    'fugitive',
    'fugitiveblame',
    'plug'
}


local pallete = {
    bright_red    = "#fb4934",
    bright_green  = "#b8bb26",
    bright_yellow = "#fabd2f",
    bright_blue   = "#83a598",
    bright_purple = "#d3869b",
    bright_aqua   = "#8ec07c",
    bright_orange = "#fe8019",

    neutral_red    = "#cc241d",
    neutral_green  = "#98971a",
    neutral_yellow = "#d79921",
    neutral_blue   = "#458588",
    neutral_purple = "#b16286",
    neutral_aqua   = "#689d6a",
    neutral_orange = "#d65d0e",

    faded_red      = "#9d0006",
    faded_green    = "#79740e",
    faded_yellow   = "#b57614",
    faded_blue     = "#076678",
    faded_purple   = "#8f3f71",
    faded_aqua     = "#427b58",
    faded_orange   = "#af3a03",

    dark0_hard    = "#1d2021",
    dark0         = "#282828",
    dark0_soft    = "#32302f",
    dark1         = "#3c3836",
    dark2         = "#504945",
    dark3         = "#665c54",
    dark4         = "#7c6f64",
    dark4_256     = "#7c6f64",

    gray_245      = "#928374",
    gray_244      = "#928374",

    light0_hard   = "#f9f5d7",
    light0        = "#fbf1c7",
    light0_soft   = "#f2e5bc",
    light1        = "#ebdbb2",
    light2        = "#d5c4a1",
    light3        = "#bdae93",
    light4        = "#a89984",
    light4_256    = "#a89984",
}

-- local colors = {
    -- bg = pallete.dark0_hard,
    -- fg = pallete.light2,
    -- filename_bg = pallete.faded_blue,
    -- filename_fg = pallete.light0_hard,
    -- git_add = pallete.neutral_green,
    -- git_rm = pallete.neutral_red,
    -- git_mod = pallete.yellow,
    -- diag_err_bg = pallete.dark0_hard,
    -- diag_err_fg = pallete.bright_red,
    -- diag_war_bg = pallete.dark0_hard,
    -- diag_war_fg = pallete.bright_yellow,
-- }

local colors = {
    bg = pallete.dark0_hard,
    fg = pallete.light0,
    section_bg = pallete.dark0_hard,
    blue = pallete.bright_blue,
    green = pallete.bright_green,
    purple = pallete.bright_purple,
    orange = pallete.bright_yellow,
    red1 = pallete.bright_red,
    red2 = pallete.bright_orange,
    yellow = pallete.bright_yellow,
    gray1 = pallete.dark2,
    gray2 = pallete.dark1,
    gray3 = pallete.dark3,
    darkgrey = pallete.dark0,
    grey = pallete.gray_245,
    middlegrey = pallete.gray_245,
}

-- Local helper functions
local is_buffer_empty = function()
    -- Check whether the current buffer is empty
    return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

local has_width_gt = function(cols)
    -- Check if the windows width is greater than a given number of columns
    return vim.fn.winwidth(0) / 2 > cols
end

local buffer_not_empty = function() return not is_buffer_empty() end

local checkwidth = function()
    return has_width_gt(35) and buffer_not_empty()
end

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value[1] == val then return true end
    end
    return false
end

local mode_color = function()
    local mode_colors = {
        [110] = colors.green,
        [105] = colors.blue,
        [99] = colors.green,
        [116] = colors.blue,
        [118] = colors.purple,
        [22] = colors.purple,
        [86] = colors.purple,
        [82] = colors.red1,
        [115] = colors.red1,
        [83] = colors.red1
    }

    mode_color = mode_colors[vim.fn.mode():byte()]
    if mode_color ~= nil then
        return mode_color
    else
        return colors.purple
    end
end

local function file_readonly()
    if vim.bo.filetype == 'help' then return '' end
    if vim.bo.readonly == true then return '  ' end
    return ''
end

local function get_current_file_name()
    local file = vim.fn.expand('%:t')
    if vim.fn.empty(file) == 1 then return '' end
    if string.len(file_readonly()) ~= 0 then return file .. file_readonly() end
    if vim.bo.modifiable then
        if vim.bo.modified then return file .. '  ' end
    end
    return file .. ' '
end

local function get_basename(file) return file:match("^.+/(.+)$") end

local GetGitRoot = function()
    local git_dir = require('galaxyline.provider_vcs').get_git_dir()
    if not git_dir then return '' end

    local git_root = git_dir:gsub('/.git/?$', '')
    return get_basename(git_root)
end

-- Left side
gls.left[1] = {
    ViMode = {
        provider = function()
            local aliases = {
                [110] = 'NORMAL',
                [105] = 'INSERT',
                [99] = 'COMMAND',
                [116] = 'TERMINAL',
                [118] = 'VISUAL',
                [22] = 'V-BLOCK',
                [86] = 'V-LINE',
                [82] = 'REPLACE',
                [115] = 'SELECT',
                [83] = 'S-LINE'
            }
            vim.api.nvim_command('hi GalaxyViMode guibg=' .. mode_color())
            alias = aliases[vim.fn.mode():byte()]
            if alias ~= nil then
                if has_width_gt(35) then
                    mode = alias
                else
                    mode = alias:sub(1, 1)
                end
            else
                mode = vim.fn.mode():byte()
            end
            return '  ' .. mode .. ' '
        end,
        highlight = {colors.bg, colors.bg, 'bold'}
    }
}
gls.left[2] = {
    FileIcon = {
        provider = {function() return '  ' end, 'FileIcon'},
        condition = buffer_not_empty,
        highlight = {
            require('galaxyline.provider_fileinfo').get_file_icon,
            colors.section_bg
        }
    }
}
gls.left[3] = {
    FileName = {
        provider = get_current_file_name,
        condition = buffer_not_empty,
        highlight = {colors.fg, colors.section_bg},
        separator = ' ',
        separator_highlight = {colors.section_bg, colors.bg}
    }
}
-- gls.left[4] = {
--     WhiteSpace = {
--         provider = trailing_whitespace,
--         condition = buffer_not_empty,
--         highlight = {colors.fg, colors.bg}
--     }
-- }
-- gls.left[5] = {
--     TabIndent = {
--         provider = tab_indent,
--         condition = buffer_not_empty,
--         highlight = {colors.fg, colors.bg}
--     }
-- }
gls.left[9] = {
    DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '  ',
        highlight = {colors.red1, colors.bg}
    }
}
gls.left[10] = {
    Space = {
        provider = function() return ' ' end,
        highlight = {colors.bg, colors.bg}
    }
}
gls.left[11] = {
    DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '  ',
        highlight = {colors.orange, colors.bg}
    }
}
gls.left[12] = {
    Space = {
        provider = function() return ' ' end,
        highlight = {colors.bg, colors.bg}
    }
}
gls.left[13] = {
    DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '  ',
        highlight = {colors.blue, colors.bg},
        separator = ' ',
        separator_highlight = {colors.bg, colors.bg}
    }
}

local function lsp_status(status)
    shorter_stat = ''
    for match in string.gmatch(status, "[^%s]+")  do
        err_warn = string.find(match, "^[WE]%d+", 0)
        if not err_warn then
            shorter_stat = shorter_stat .. ' ' .. match
        end
    end
    return shorter_stat
end

local function get_coc_lsp()
  local status = vim.fn['coc#status']()
  if not status or status == '' then
      return ''
  end
  return lsp_status(status)
end

function get_diagnostic_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_lsp()
    end
  return ''
end

CocStatus = get_diagnostic_info

gls.right[1] = {
    CocStatus = {
     provider = CocStatus,
     highlight = {colors.fg, colors.bg},
     -- icon = ' COC: '
    }
}

local function get_current_func()
  local has_func, func_name = pcall(vim.fn.nvim_buf_get_var,0,'coc_current_function')
  if not has_func then
    return
  end
  return func_name
end
CocFunc = get_current_func

gls.right[2] = {
  CocFunc = {
    provider = CocFunc,
    icon = '  λ ',
    highlight = {colors.fg, colors.bg},
  }
}

-- Right side
gls.right[3] = {
    DiffAdd = {
        provider = 'DiffAdd',
        condition = checkwidth,
        icon = '+',
        highlight = {colors.green, colors.bg}
    }
}
gls.right[4] = {
    DiffModified = {
        provider = 'DiffModified',
        condition = checkwidth,
        icon = '~',
        highlight = {colors.orange, colors.bg}
    }
}
gls.right[5] = {
    DiffRemove = {
        provider = 'DiffRemove',
        condition = checkwidth,
        icon = '-',
        highlight = {colors.red3, colors.bg}
    }
}
gls.right[6] = {
    Space = {
        provider = function() return ' ' end,
        highlight = {colors.bg, colors.bg}
    }
}
gls.right[7] = {
    GitIcon = {
        provider = function() return '  ' end,
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = {colors.middlegrey, colors.bg}
    }
}
gls.right[8] = {
    GitBranch = {
        provider = 'GitBranch',
        condition = require("galaxyline.provider_vcs").check_git_workspace,
        highlight = {colors.middlegrey, colors.bg}
    }
}
gls.right[9] = {
    GitRoot = {
        provider = {GetGitRoot, function() return ' ' end},
        condition = function()
            return has_width_gt(47) and require("galaxyline.provider_vcs").check_git_workspace
        end,
        highlight = {colors.middlegrey, colors.bg}
    }
}

gls.right[10] = {
    ScrollBar = {
        separator = ' ',
        provider = 'LineColumn',
        separator_highlight = {colors.purple, colors.bg},
        highlight = {colors.purple, colors.bg}
    }
}

gls.right[11] = {
    PerCent = {
        provider = 'LinePercent',
        separator = ' ',
        separator_highlight = {colors.blue, colors.bg},
        highlight = {colors.gray4, colors.blue}
    }
}

-- Short status line
gls.short_line_left[1] = {
    FileIcon = {
        provider = {function() return '  ' end, 'FileIcon'},
        condition = function()
            return buffer_not_empty and
                       has_value(gl.short_line_list, vim.bo.filetype)
        end,
        highlight = {
            require('galaxyline.provider_fileinfo').get_file_icon,
            colors.bg
        }
    }
}
gls.short_line_left[2] = {
    FileName = {
        provider = get_current_file_name,
        condition = buffer_not_empty,
        highlight = {colors.fg, colors.bg},
        separator = ' ',
        separator_highlight = {colors.bg, colors.bg}
    }
}

gls.short_line_right[1] = {
    BufferIcon = {
        provider = 'BufferIcon',
        highlight = {colors.yellow, colors.bg},
        separator = '',
        separator_highlight = {colors.bg, colors.bg}
    }
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()

