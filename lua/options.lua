local utils = require("utils")
local opt = vim.opt

local paths = require("paths")

-- Variables
vim.g.python3_host_prog = paths.join_path(
  {
    vim.fn.stdpath("data"),
    "installables",
    "python",
    "bin",
    "python3"
  }
)

-- Colors
opt.termguicolors = true
opt.background = "dark"

-- Split direction
opt.splitbelow = true
opt.splitright = true

-- Resize sign column limit
opt.signcolumn = "yes:1"

-- Color line/column
opt.colorcolumn = "90"
opt.cursorline = true
-- opt.cmdheight = 0
opt.splitkeep = "topline"

-- Completion menu
opt.pumheight = 20
opt.pumblend = 10

-- Set encoding
opt.encoding = "utf-8"

-- Hidden buffers to switch buffers without saving
opt.hidden = true

-- Enable mouse support
opt.mouse = "a"

-- Auto read file changes
opt.autoread = true

-- Make last window always have a status line
opt.laststatus = 3

-- Indent
opt.tabstop = 4 -- visual spaces that a tab represents
opt.softtabstop = 4 -- editing spaces that a tab (and its backspace) represent
opt.shiftwidth = 4 -- spaces used in autoindent (<< and >>)
opt.expandtab = true -- turn spaces into tabs?
opt.autoindent = true
opt.smartindent = true

-- Wrap behavior
opt.wrap = false

-- Line numbers
opt.number = true

-- Folding (with Treesitter)
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
-- opt.foldenable = true  -- start with all folded

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Faster update time
opt.updatetime = 200

-- Scroll offsets
opt.scrolloff = 5
opt.sidescrolloff = 4

-- Fillchars
opt.fillchars = "diff:╱"
opt.list = true
opt.listchars = { tab = "  " }

-- Jumplist
opt.jumpoptions = "stack"

-- Use filetype in lua
vim.filetype.add({
  filename = {
    ["MLproject"] = "yaml",
  }
})

-- Diff options
-- waiting on: https://github.com/neovim/neovim/pull/14537
-- oddly enough, this option isn't set as a table
opt.diffopt = "filler,vertical,closeoff,internal,indent-heuristic,algorithm:patience"

vim.g.loaded_matchparen = 1

-- Folds
function _G.custom_fold_expr()
  local line = vim.fn.getline(vim.v.foldstart)
  local sub = vim.fn.substitute(line, [[/*|*/|{{{\d=]], "", "g")
  return sub .. " (" .. tostring(vim.v.foldend - vim.v.foldstart) .. " lines)"
end
opt.foldtext = "v:lua.custom_fold_expr()"

-- Highlight text on yank
utils.create_augroup("highlight_on_yank", {
  { "TextYankPost", "*", "silent!", "lua vim.highlight.on_yank()" },
})

-- Autocommands
-- don't list quickfix buffers in tabline
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

