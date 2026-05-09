local Snacks = require("snacks")

Snacks.setup({
  picker = {
    enabled = true,
    matcher = { ignorecase = true },
  },
  explorer = { enabled = true },
  terminal = { enabled = false },
  notifier = { enabled = true },
  bigfile = { enabled = true },
  gitbrowse = { enabled = true },
  lazygit = {
    enabled = true,
    configure = true,
    win = { position = "float" },
  },
})

local map = vim.keymap.set

-- file picker (like Ctrl-p)
map("n", "<C-p>", function() Snacks.picker.files({ hidden = true }) end, { desc = "Find files" })
map("n", "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, { desc = "Find files" })

-- grep across project
map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep search" })
map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Grep search" })

-- buffers
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find buffers" })
map("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Find buffers" })

-- explorer sidebar
map("n", "<leader>n", function() Snacks.picker.explorer({ hidden = true }) end, { desc = "File explorer" })

-- recent files
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent files" })

-- help
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help" })

-- extra file pickers (matching Rakshan's binds)
map("n", "<leader>p", function() Snacks.picker.files({ hidden = true }) end, { desc = "Find files" })
map("n", "<leader>r", function() Snacks.picker.grep() end, { desc = "Grep search" })

-- search in current file
map("n", "<leader>sf", function() Snacks.picker.lines() end, { desc = "Search current file" })

-- search in open buffers
map("n", "<leader>sb", function() Snacks.picker.grep_buffers() end, { desc = "Search open buffers" })

-- grep files with same extension as current file
map("n", "<leader>fe", function()
  local ext = vim.fn.expand("%:e")
  if ext and ext ~= "" then
    Snacks.picker.grep({ args = { "--glob=*." .. ext } })
  else
    vim.notify("Current buffer has no file extension", vim.log.levels.WARN)
  end
end, { desc = "Grep same extension" })

-- git
map("n", "<leader>gl", function() Snacks.lazygit.open() end, { desc = "LazyGit" })
map("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git blame line" })
map("n", "<leader>go", function() Snacks.gitbrowse() end, { desc = "Open in GitHub" })
