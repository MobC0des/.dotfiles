return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
    dependencies = {
      -- LSP installer plugins
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local map_lsp_keybinds = require("mobc0des.keymaps").map_lsp_keybinds

      -- List your LSP servers here.
      local servers = {
        bashls = {},
        biome = {},
        cssls = {},
        eslint = {
          autostart = false,
          cmd = { "vscode-eslint-language-server", "--stdio" },
          settings = { format = false },
        },
        html = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
              },
              telemetry = { enabled = false },
            },
          },
        },
        marksman = {},
        oxlint = {
          root_markers = { ".oxlintrc.json" },
        },
        tailwindcss = {
          filetypes = { "typescriptreact", "javascriptreact", "html", "astro" },
        },
        yamlls = {},
      }

      local formatters = {
        prettierd = {},
        stylua = {},
      }

      local ensure_installed = vim.tbl_keys(vim.tbl_deep_extend("force", {}, servers, formatters))

      require("mason-tool-installer").setup({
        auto_update = true,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 12,
        ensure_installed = ensure_installed,
      })

      -- Extend Neovim's LSP capabilities with Blink completion support.
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
      )

      -- Setup LspAttach autocmd for keybindings (replaces on_attach)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local bufname = vim.api.nvim_buf_get_name(bufnr)

          -- Detach from non-file buffers.
          if bufname == "" then
            vim.schedule(function()
              vim.lsp.buf_detach_client(bufnr, event.data.client_id)
            end)
            return
          end

          map_lsp_keybinds(bufnr)
        end,
      })

      -- Setup each LSP server using the new vim.lsp.config API
      for name, config in pairs(servers) do
        -- Configure the server
        vim.lsp.config(name, {
          cmd = config.cmd,
          capabilities = capabilities,
          filetypes = config.filetypes,
          settings = config.settings,
          root_dir = config.root_dir,
          root_markers = config.root_markers,
        })

        -- Enable the server (with autostart setting if specified)
        if config.autostart == false then
          -- Don't auto-enable servers with autostart = false
          -- Users can manually enable with :lua vim.lsp.enable(name)
        else
          vim.lsp.enable(name)
        end
      end

      -- Setup Mason for managing external LSP servers
      require("mason").setup({ ui = { border = "rounded" } })
      require("mason-lspconfig").setup()
    end,
  },
}
