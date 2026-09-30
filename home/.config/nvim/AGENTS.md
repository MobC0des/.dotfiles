# NEOVIM CONFIG

**Updated:** 2026-09-30

Lua-based Neovim config managed with lazy.nvim. TypeScript/JavaScript-focused, with JJ/Git-aware VCS tooling and a small set of explicitly chosen editor utilities.

## STRUCTURE

```text
nvim/
├── init.lua                    # Entry: require("mobc0des")
├── lua/
│   ├── mobc0des/
│   │   ├── init.lua            # Orchestrates config modules
│   │   ├── keymaps.lua         # Global + exported LSP keybindings
│   │   ├── options.lua         # vim.opt settings
│   │   ├── lazy.lua            # lazy.nvim bootstrap
│   │   ├── prelude.lua         # Shared utility functions
│   │   └── ...                 # Small editor utilities
│   └── plugins/                # Plugin specs, generally one file per plugin
└── after/                      # Filetype-specific overrides where needed
```

## WHERE TO LOOK

| Task                 | Location                                            |
| -------------------- | --------------------------------------------------- |
| Add plugin           | `lua/plugins/<name>.lua` returning a lazy.nvim spec |
| Add keymap           | `lua/mobc0des/keymaps.lua`                          |
| Change option        | `lua/mobc0des/options.lua`                          |
| LSP server           | `lua/plugins/lsp.lua` — add to `servers` table      |
| Formatter            | `lua/plugins/conform.lua`                           |
| Completion           | `lua/plugins/blink-cmp.lua`                         |
| Snippets             | `lua/plugins/luasnip.lua`                           |
| TypeScript           | `lua/plugins/typescript-tools.lua`                  |
| Type inspection      | `lua/plugins/two-slash.lua`                         |
| VCS signs            | `lua/plugins/vcsigns.lua`                           |
| File explorer        | `lua/plugins/oil.lua`                               |
| Statusline           | `lua/plugins/lualine.lua`                           |
| General UI utilities | `lua/plugins/snacks.lua`                            |
| Theme                | `lua/plugins/color-scheme.lua`                      |

## CONVENTIONS

- Plugin files return lazy.nvim spec tables.
- Plugins lazy-load via `event`, `ft`, `cmd`, or `keys` where appropriate.
- LSP uses the Neovim 0.11+ APIs:
  - `vim.lsp.config()`
  - `vim.lsp.enable()`
- LSP keymaps are attached per-buffer via the `LspAttach` autocmd.
- Empty/non-file buffers are detached from LSP.
- Completion is owned by `blink.cmp`, not `nvim-cmp`.
- LuaSnip owns snippet expansion and `friendly-snippets`.
- Conform owns formatting.
- TypeScript/JavaScript language tooling is owned by `typescript-tools.nvim`.
- `vcsigns.nvim` owns in-editor change awareness.
- JJ is preferred over Git where both are available.
- Navigation commonly recenters with `zz`.
- Shared modules use the `local M = {}` / `return M` pattern where exports are required.

## AVOID

- `nvim-cmp` for completion — use Blink.
- `cmp-nvim-lsp` — Blink provides the LSP capabilities.
- `tsserver` through normal lspconfig setup — use `typescript-tools.nvim`.
- Git-centric editor tooling when JJ/local change awareness is sufficient.
- Adding language servers, parsers, formatters, or plugins for languages not actually used.
- Multiple formatters running over the same file.
- Formatter activation without a project-level configuration file.
- Duplicate plugin ownership across multiple plugin files.

## KEY BINDINGS

| Key           | Mode | Action                              |
| ------------- | ---- | ----------------------------------- |
| `jj` / `JJ`   | i    | Exit insert mode                    |
| `H` / `L`     | n,v  | Line start/end                      |
| `U`           | n    | Redo                                |
| `S`           | n    | Quick substitute word under cursor  |
| `<leader>e`   | n    | Toggle Oil file explorer            |
| `<leader>w`   | n    | Save current buffer                 |
| `<leader>q`   | n    | Quit current buffer                 |
| `<leader>'`   | n    | Switch to previous buffer           |
| `<leader>f`   | n    | Format current buffer               |
| `<leader>sf`  | n    | Find files                          |
| `<leader>sg`  | n    | Live grep                           |
| `<leader>sb`  | n    | Search open buffers                 |
| `<leader>/`   | n    | Fuzzy search current buffer         |
| `<leader>ti`  | n    | Inspect TwoSlash query              |
| `<leader>ts`  | n    | Toggle TwoSlash queries             |
| `<leader>rw`  | n    | Rotate windows                      |
| `<leader>og`  | n,v  | Open current location in Git remote |
| `<leader>bd`  | n    | Delete current buffer               |
| `<leader>nh`  | n    | Notification history                |
| `<leader>nd`  | n    | Dismiss notifications               |
| `<leader>tx`  | n    | Toggle Treesitter Context           |
| `<leader>ih`  | n    | Toggle inlay hints                  |
| `<leader>hl`  | n    | Toggle inline colour highlighting   |
| `<leader>td`  | n    | Toggle diagnostics                  |
| `<leader>tw`  | n    | Toggle line wrapping                |
| `gx`          | n    | Open link under cursor              |
| `]d` / `[d`   | n    | Next/previous diagnostic            |
| `]e` / `[e`   | n    | Next/previous error                 |
| `]w` / `[w`   | n    | Next/previous warning               |
| `]c` / `[c`   | n    | Next/previous VCS hunk              |
| `]C` / `[C`   | n    | Last/first VCS hunk                 |
| `<leader>hu`  | n,v  | Undo VCS hunk                       |
| `<leader>hd`  | n    | Toggle inline hunk diff             |
| `<leader>hf`  | n    | Fold non-hunk lines                 |
| `[r` / `]r`   | n    | Change VCS comparison target        |
| `<C-h/j/k/l>` | n    | Window/pane navigation              |

## LSP SERVERS

Configured through `lua/plugins/lsp.lua`:

- `bashls`
- `biome`
- `cssls`
- `eslint`
  - does not autostart
  - formatting disabled
- `html`
- `jsonls`
- `lua_ls`
  - LuaJIT runtime
  - Neovim/Lua support supplemented by `lazydev.nvim`
- `marksman`
- `oxlint`
  - only rooted where `.oxlintrc.json` exists
- `tailwindcss`
  - TSX, JSX, HTML and Astro
- `yamlls`

TypeScript and JavaScript are handled separately by `typescript-tools.nvim`.

## TYPESCRIPT / JAVASCRIPT

`typescript-tools.nvim` owns TypeScript and JavaScript language intelligence.

Configured behavior includes:

- separate diagnostic server
- diagnostics published on insert leave
- JSX/TSX close-tag support
- parameter, variable, property, function, enum and return-type inlay hints
- auto-import completions
- completion support for module exports/import statements
- complete function-call support
- TwoSlash attachment

TwoSlash starts disabled and can be toggled when type inspection is useful.

`ts-error-translator.nvim` rewrites dense TypeScript diagnostics into more readable explanations.

## FORMATTER CHAIN

Formatting is owned by `conform.nvim`.

### JavaScript / TypeScript / TSX / Astro

```text
oxfmt
→ biome
→ prettierd
→ LSP fallback
```

Only the first applicable formatter runs.

Each formatter is conditional:

- `oxfmt` requires `.oxfmtrc.json` or `.oxfmtrc.jsonc`
- Biome requires `biome.json` or `biome.jsonc`
- Prettier requires a recognised Prettier config file

### Lua

```text
stylua
```

Formatting runs after save unless disabled.

Commands:

```text
:ConformDisable
:ConformDisable!
:ConformEnable
```

`ConformDisable!` disables formatting only for the current buffer.

## COMPLETION

Completion is owned by `blink.cmp`.

Sources:

```text
LSP
paths
snippets
buffer
```

LSP results have the highest priority.

Other behaviour:

- ghost text enabled
- documentation popup enabled
- signature help enabled
- LuaSnip used for snippet expansion
- Tab / Shift-Tab navigate suggestions or snippet placeholders
- Enter accepts the selected completion
- completion menu shows the source of each suggestion

## SNIPPETS

LuaSnip owns snippets.

Sources:

- `friendly-snippets`
- custom VS Code-style snippets
- custom Lua snippets

Autosnippets are enabled.

## VCS

### vcsigns.nvim

Provides editor-local change awareness.

- works with JJ/Git repositories
- compares against the parent by default
- gutter signs for added/changed/removed lines
- hunk navigation
- inline hunk diffs
- hunk undo
- changed-region folding
- comparison target navigation

### Lualine

The statusline checks JJ first.

For JJ repositories it shows:

- current bookmark when present
- otherwise the short change ID

For non-JJ repositories it falls back to the Git branch.

It also shows:

- vcsigns diff counts
- diagnostics
- relative filename
- filetype

## FILE MANAGEMENT

Oil is the primary in-editor file explorer.

- opens directories as editable buffers
- hidden files shown
- floating UI uses rounded borders
- file moves are passed to `Snacks.rename`
- rename events can therefore be propagated to language tooling

## TREESITTER

Treesitter provides syntax-aware parsing and editing.

Installed parsers are kept intentionally limited to languages in use.

`nvim-treesitter-textobjects` provides:

- parameter selection
- function selection
- class selection
- syntax-aware movement
- incremental selection

`nvim-treesitter-context` is installed but disabled by default.

Use:

```text
<leader>tx
```

to toggle one line of surrounding syntax context when needed.

## UI / EDITING UTILITIES

- **Catppuccin Macchiato** — editor theme, matching Ghostty
- **Wilder** — enhanced `:`, `/`, and `?` command/search UI
- **WhichKey** — discoverability for keybindings
- **Fidget** — LSP/progress feedback
- **tiny-inline-diagnostic** — replaces default virtual-text diagnostics
- **Snacks** — notifications, toggles, buffer deletion, Git browsing, scratch buffers, rename integration and other small utilities
- **render-markdown** — improved Markdown rendering
- **nvim-highlight-colors** — inline CSS/Tailwind colour previews
- **nvim-web-devicons** — shared filetype icons
- **nvim-autopairs** — automatic brackets/quotes
- **vim-surround** — add/change/delete surrounding characters
- **nvim-ts-autotag** — automatic HTML/JSX/TSX tag closing and renaming
- **Dressing** — improved `vim.ui.input` / `vim.ui.select`
- **Cloak** — visually masks values in `.env`, `.vars`, `.secrets`, and selected token config files
- **UFO** — code folding

## REMOVED / NO LONGER USED

These were inherited from the original config but have intentionally been removed:

- Harpoon
- UndoTree UI
- Spectre
- Outline
- Diffview
- `tsc.nvim`
- `vim-maximizer`
- `nvim-cmp`
- `cmp-nvim-lsp`
- Rust LSP tooling
- Svelte LSP tooling
- Zig LSP tooling
- SQL LSP tooling
- Fugitive-specific LSP handling

The general rule is:

> Keep a plugin when it has a clear job in the current workflow. Remove inherited functionality that has no active use.
