local set_keymap = vim.keymap.set

local M = {}

--        nvim-dap
-- ──────────────────────────────
local dap = require("dap")
local dapui = require("dapui")

set_keymap("n", "<Leader>db", dap.toggle_breakpoint)
set_keymap("n", "<Leader>dc", dap.continue)
set_keymap("n", "<Leader>dj", dap.step_over)
set_keymap("n", "<Leader>dl", dap.step_into)
set_keymap("n", "<Leader>dh", dap.step_out)
set_keymap("n", "<Leader>dr", dap.repl.open)
set_keymap("n", "<Leader>ds", function() dap.close(); dapui.close() end)

vim.cmd("au FileType dap-repl lua require('dap.ext.autocompl').attach()")
vim.fn.sign_define("DapBreakpoint", { text = "🔺", texthl = "", linehl = "", numhl = "" })

-- nvim-dap convenience functions
function M.pick_process()
  local output = vim.fn.system({ "ps", "a" })
  local lines = vim.split(output, "\n")
  local procs = {}
  for _, line in pairs(lines) do
    -- output format
    --    " 107021 pts/4    Ss     0:00 /bin/zsh <args>"
    local parts = vim.fn.split(vim.fn.trim(line), " \\+")
    local pid = parts[1]
    local name = table.concat({ unpack(parts, 5) }, " ")
    if pid and pid ~= "PID" then
      pid = tonumber(pid)
      if pid ~= vim.fn.getpid() then
        table.insert(procs, { pid = tonumber(pid), name = name })
      end
    end
  end
  local choices = { "Select process" }
  for i, proc in ipairs(procs) do
    table.insert(choices, string.format("%d: pid=%d name=%s", i, proc.pid, proc.name))
  end
  local choice = vim.fn.inputlist(choices)
  if choice < 1 or choice > #procs then
    return nil
  end
  return procs[choice].pid
end

--          adapters
-- ──────────────────────────────
dap.adapters.python_launch = {
  type = "executable",
  command = vim.fn.expand("python3"),
  args = { "-m", "debugpy.adapter" },
  initialize_timeout_sec = 5,
}
dap.adapters.python_attach = {
  type = "server",
  host = "127.0.0.1",
  port = "5678",
}

--          configs
-- ──────────────────────────────
dap.configurations.python = {
  {
    name = "Launch script",
    type = "python_launch",
    request = "launch",
    program = "${file}",
    args = function ()
      local args = vim.fn.input({ prompt = "Script args: "})
      args = vim.fn.split(args, " ")
      return args
    end,
    cwd = "${workspaceFolder}",
    pythonPath = "python3",
  },
  {
    name = "Launch module",
    type = "python_launch",
    request = "launch",
    cwd = "${workspaceFolder}",
    module = function()
      local name = vim.fn.expand("%:r")
      name = string.gsub(name, "/", ".")
      name = string.gsub(name, "\\", ".")
      return name
    end,
    args = function ()
      local args = vim.fn.input({ prompt = "Module args: "})
      args = vim.fn.split(args, " ")
      return args
    end,
    pythonPath = "python3",
  },
  {
    name = "Attach",
    type = "python_attach",
    request = "attach",
  },
}

--          dapui
-- ──────────────────────────────
dapui.setup({
  icons = {
    expanded = "―",
    collapsed = "=",
  },
  mappings = {
    expand = { "<Tab>", "<2-LeftMouse>" },
    open = "<CR>",
    remove = "dd",
    edit = "e",
  },
  sidebar = {
    elements = {
      -- You can change the order of elements in the sidebar
      { id = "scopes", size = 0.4 },
      { id = "breakpoints", size = 0.1 },
      { id = "stacks", size = 0.2 },
      { id = "watches" , size = 0.2 },
    },
    size = 40,
    position = "left", -- Can be "left" or "right"
  },
  tray = {
    elements = {
      "repl",
    },
    size = 10,
    position = "bottom", -- Can be "bottom" or "top"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
  },
})

-- load launch.json
require('dap.ext.vscode').load_launchjs(vim.fn.getcwd() .. '/launch.json')

-- start ui automatically
dap.listeners.after["event_initialized"]["custom_dapui"] = function()
  dapui.open()
end

return M
