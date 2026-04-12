# Neovim Configuration

## Project Overview

A personal Neovim configuration built on top of Kickstart.nvim. It extends the minimal kickstart foundation with custom plugins for AI assistance, Git workflow, file navigation, and multi-language LSP support. The configuration targets C/C++, Rust, Lua, TypeScript development with Chinese-language comments and documentation.

## Tech Stack

- **Editor**: Neovim (requires 0.10+)
- **Plugin Manager**: lazy.nvim — lazy-loading, auto-install, declarative plugin specs
- **LSP**: nvim-lspconfig + Mason (auto-install LSP servers, formatters, DAP adapters)
- **Completion**: nvim-cmp (primary) + blink.cmp (custom alternative)
- **Fuzzy Finder**: Telescope with fzf-native backend
- **Syntax**: Treesitter (highlighting, folding, indentation)
- **AI**: avante.nvim with Gemini API
- **Formatting**: conform.nvim (stylua, clang-format, prettier)
- **Debugging**: nvim-dap with codelldb

## Directory Structure

```
init.lua                    # Bootstrap entry: vim options, keymaps, lazy.nvim setup, LSP/completion/treesitter config
lua/
  kickstart/
    health.lua              # Healthcheck for kickstart dependencies
    plugins/                # Optional kickstart modules (debug, neo-tree, autopairs, indent, lint, gitsigns)
  custom/
    plugins/                # User plugin specs — each file returns a lazy.nvim plugin table
      init.lua              # Custom vim options (tabstop, clipboard, folding, auto-save)
      keymaps.lua           # Custom keybindings (terminal, buffer, escape)
doc/                        # Help documentation
快捷键总览.md               # Comprehensive keybinding reference (Chinese)
.stylua.toml                # Lua formatter config
```

## Architectural Decisions

- **Kickstart as foundation, not fork**: init.lua preserves kickstart's single-file structure for core config (LSP, completion, treesitter). Customizations live in `lua/custom/plugins/` to keep upgrade path clean.
- **One file per plugin in custom/**: lazy.nvim's `import` directive auto-loads all files in `lua/custom/plugins/`, so adding a plugin means creating a single file — no registration step needed.
- **init.lua in custom/plugins for non-plugin settings**: Custom vim options, autocommands, and clipboard logic live in `lua/custom/plugins/init.lua` as a pseudo-plugin (returns an empty table) to stay within lazy.nvim's import mechanism.
- **SSH-aware clipboard**: Detects SSH sessions via `$SSH_TTY` and switches to OSC 52 protocol, enabling clipboard sharing over remote connections.
- **Treesitter folding over manual folds**: Uses `expr` foldmethod with treesitter queries — folds are always semantically correct without manual maintenance.
- **Dual colorscheme retention**: Both Nord (active) and Catppuccin are installed; the inactive one is set to `lazy = true` so it loads only on demand via `:colorscheme`.

## Common Commands

```bash
# Open Neovim (plugins auto-install on first launch)
nvim

# Update all plugins
# Inside Neovim: :Lazy update

# Install/update LSP servers and tools
# Inside Neovim: :Mason

# Check configuration health
# Inside Neovim: :checkhealth

# Format Lua files (CLI)
stylua lua/ init.lua
```

## Coding Standards

- All plugin spec files return a single Lua table (or list of tables) following lazy.nvim's spec format.
- Keymaps always include `desc` field for which-key discoverability.
- Leader key is `<space>`. Namespaces: `c` code, `s` search, `d` document, `r` rename, `w` workspace, `t` toggle, `h` git hunk, `g` git, `f` format, `m` marks, `a` AI.
- Comments are written in Chinese; code identifiers and strings remain in English.
- LSP server configs are defined in the `servers` table within init.lua — each entry is the server name mapped to its settings override.
- Formatters follow a fallback pattern: tool-specific formatter first, then LSP as fallback (`lsp_format = 'fallback'`).

## Module Dependencies

```
init.lua
  ├── lazy.nvim (bootstrapped from GitHub, manages all plugins)
  │     ├── imports kickstart.plugins.*  (optional base modules)
  │     └── imports custom.plugins.*     (user extensions)
  │
  ├── LSP pipeline: mason → mason-lspconfig → lspconfig → per-buffer keymaps via LspAttach
  ├── Completion: nvim-cmp ← cmp-lsp + cmp-path + luasnip
  ├── Formatting: conform.nvim (triggered by <leader>f or format-on-save)
  └── Treesitter: nvim-treesitter (highlight, indent, fold expressions)

custom/plugins/lualine.lua depends on harpoon.lua (reads harpoon list for tabline display)
custom/plugins/avante.lua depends on render-markdown.lua (renders AI response as markdown)
```
