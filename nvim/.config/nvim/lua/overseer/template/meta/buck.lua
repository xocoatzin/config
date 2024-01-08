local overseer = require("overseer")

---@type overseer.TemplateDefinition
local tmpl = {
  name = "buck",
  priority = 30,
  params = {
    args = { optional = true, type = "list", delimiter = " " },
    env = { optional = true, type = "list", delimiter = " " },
  },
  builder = function(params)
    local cmd = { "echo" }
    -- if params.args then
    --   cmd = vim.list_extend(cmd, params.args)
    -- end
    return {
      cmd = cmd,
      -- strategy = "toggleterm",
      args = params.args or {},
      env = params.env or {},
    }
  end,
}

local buck_mode = "@arvr/mode/mac/rosetta/opt"
local buck_target = "//arvr/python/daco/flavors/ar_slam_web:ar_slam_web"

return {
  -- cache_key = function(opts)
  --   return get_toxfile(opts)
  -- end,
  condition = {
    callback = function(opts)
      return true
    end,
  },
  generator = function(opts, cb)
    cb({
      overseer.wrap_template(tmpl, { name = "buck build" }, { args = { "build", buck_mode, buck_target } }),
      overseer.wrap_template(tmpl, { name = "buck run" }, { args = { "run", "$DACO" }, env = { DACO = "DACOss" } }),
    })
  end,
}

-- -- DACO_DB_DIR=~/daco buck run @arvr/mode/mac/rosetta/opt //arvr/python/daco/flavors/ar_slam_web:ar_slam_web -- -v  web --port 8080 --host 0.0.0.0 --no-data-source-monitor --data-source-url disabled;
--
-- return {
--   name = "Buck Build",
--   builder = function(params)
--     -- This must return an overseer.TaskDefinition
--     return {
--       cmd = { "buck" },
--       args = {
--         "build",
--         "@arvr/mode/mac/rosetta/opt",
--         "//arvr/python/daco/flavors/ar_slam_web:ar_slam_web",
--         "--show-output",
--       },
--       name = "Build",
--       -- cwd = "/tmp",
--       env = {
--         DACO_DB_DIR = "~/daco",
--       },
--       -- the list of components or component aliases to add to the task
--       components = { "default" },
--       -- arbitrary table of data for your own personal use
--       metadata = {
--         foo = "bar",
--       },
--     }
--   end,
--   -- Optional fields
--   desc = "Buck build",
--   -- Tags can be used in overseer.run_template()
--   tags = { overseer.TAG.BUILD },
--   params = {
--     -- See :help overseer-params
--   },
--   -- Lower comes first.
--   priority = 50,
--   condition = {
--     -- filetype = { "c", "cpp" },
--     -- dir = "/home/user/my_project",
--     callback = function(search)
--       -- print(vim.inspect(search))
--       -- {
--       --   dir = "/Users/ator/fbsource/arvr/python/daco/flavors/ar_slam_web/orchestration/",
--       --   filetype = "python",
--       --   tags = {}
--       -- }
--       return true
--     end,
--   },
-- }
