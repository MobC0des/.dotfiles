vim.api.nvim_create_user_command("CopyFilePathToClipboard", function()
  local file_path = vim.api.nvim_buf_get_name(0)

  if file_path == "" then
    return
  end

  -- Make the path relative to Neovim's current working directory.
  local relative_path = vim.fn.fnamemodify(file_path, ":.")
  vim.fn.setreg("+", relative_path)
end, {})

vim.api.nvim_create_user_command("CFP", function()
  vim.cmd("CopyFilePathToClipboard")
end, {})
