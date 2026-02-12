vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*.rs", -- Only for Rust files
  callback = function()
    vim.cmd("silent w | compiler cargo | make c") -- Save the file silently
  end,
  desc = "Auto-save Rust files when leaving Insert mode",
})
