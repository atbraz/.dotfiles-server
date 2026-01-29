-- =============================================================================
-- init.lua - Minimal Server Configuration
-- =============================================================================
-- Lua equivalent of .vimrc. No plugins, server-focused.
--
-- Structure:
--   1. General
--   2. Display
--   3. Search
--   4. Indentation
--   5. Files
--   6. Key bindings
--   7. Terminal
--   8. Colors
--   9. Autocommands
-- =============================================================================

-- =============================================================================
-- General
-- =============================================================================
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.hidden = true
vim.opt.autoread = true
vim.opt.history = 1000
vim.opt.undolevels = 1000
vim.opt.clipboard = "unnamedplus"

-- =============================================================================
-- Display
-- =============================================================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.laststatus = 2
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.display:append("lastline")
vim.opt.wrap = false
vim.opt.listchars = { tab = "> ", trail = "-", extends = ">", precedes = "<", nbsp = "+" }
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- =============================================================================
-- Search
-- =============================================================================
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- =============================================================================
-- Indentation
-- =============================================================================
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- =============================================================================
-- Files
-- =============================================================================
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.filetype.add({})

-- =============================================================================
-- Key Bindings
-- =============================================================================
vim.g.mapleader = " "

-- Clear search highlight
vim.keymap.set("n", "<leader><space>", "<cmd>nohlsearch<CR>")

-- Quick save and quit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Move lines up/down
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==")
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Y yanks to end of line (consistent with D, C)
vim.keymap.set("n", "Y", "y$")

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>")

-- =============================================================================
-- Terminal
-- =============================================================================
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- =============================================================================
-- Colors
-- =============================================================================
vim.opt.background = "dark"
vim.opt.termguicolors = true
pcall(vim.cmd.colorscheme, "habamax")

-- Status line
vim.opt.statusline = "%f %m%r%h%w%=%l/%L %c %p%%"

-- =============================================================================
-- Autocommands
-- =============================================================================
local augroup = vim.api.nvim_create_augroup("ServerConfig", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lines = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lines then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})
