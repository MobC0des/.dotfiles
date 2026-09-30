local M = {}

local function copy_line_diagnostics_to_clipboard()
  local diag = require("tiny-inline-diagnostic")

  -- Get diagnostics for the current line
  local diagnostics = diag.get_diagnostic_under_cursor()

  if #diagnostics == 0 then
    Snacks.notify.info("No diagnostics on the current line.")
    return
  end

  -- Format diagnostics into a single string
  local diagnostic_messages = {}
  for _, diagnostic in ipairs(diagnostics) do
    table.insert(diagnostic_messages, diagnostic.message)
  end
  local result = table.concat(diagnostic_messages, "\n")

  -- Copy the result to the system clipboard
  vim.fn.setreg("+", result)
  Snacks.notify.info("Diagnostics copied to clipboard.")
end

M.copy_line_diagnostics_to_clipboard = copy_line_diagnostics_to_clipboard

local function open_link()
  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")

  -- Pattern for markdown links: [text](url)
  local md_link_pattern = "%[.-%]%((.-)%)"
  -- Pattern for bare URLs (simplified, covers most cases)
  local url_pattern = "https?://[%w-_%.%?%.:/%+=&]+"

  -- Check if cursor is on a markdown link
  local start_pos = 1
  while true do
    local md_start, md_end, url = line:find(md_link_pattern, start_pos)
    if not md_start then
      break
    end

    if col >= md_start and col <= md_end then
      vim.fn.system("open " .. vim.fn.shellescape(url))
      return
    end
    start_pos = md_end + 1
  end

  -- Check for URLs (including those in parentheses)
  start_pos = 1
  while true do
    local url_start, url_end = line:find(url_pattern, start_pos)
    if not url_start then
      break
    end

    if col >= url_start and col <= url_end then
      local url = line:sub(url_start, url_end)
      vim.fn.system("open " .. vim.fn.shellescape(url))
      return
    end
    start_pos = url_end + 1
  end

  -- Fallback to original behavior using cWORD
  vim.cmd("sil !open <cWORD>")
end

M.open_link = open_link

return M
