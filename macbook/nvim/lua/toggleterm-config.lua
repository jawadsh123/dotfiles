require("toggleterm").setup({
  open_mapping = [[<C-\>]],
  direction = "tab",
  shade_terminals = false,
})

local map = vim.keymap.set

map("n", "<leader>tt", "<cmd>ToggleTerm direction=tab<CR>", { desc = "Toggle terminal (tab)" })
map("n", "<leader>tn", "<cmd>TermNew direction=horizontal<CR>", { desc = "New terminal (horizontal)" })

-- double escape to exit terminal mode
local esc_timer
map("t", "<Esc>", function()
  esc_timer = esc_timer or (vim.uv or vim.loop).new_timer()
  if esc_timer:is_active() then
    esc_timer:stop()
    vim.cmd("stopinsert")
  else
    esc_timer:start(200, 0, function() end)
    return "<Esc>"
  end
end, { expr = true, desc = "Double escape to normal mode" })

-- navigate out of terminal with Ctrl-hjkl
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Move to left window" })
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Move to lower window" })
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Move to upper window" })
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Move to right window" })
