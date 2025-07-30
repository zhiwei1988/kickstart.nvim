# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Neovim configuration based on kickstart.nvim with custom plugins and Chinese language support. The configuration follows a modular approach with custom extensions for enhanced development workflow.

## Plugin Management

- **Plugin Manager**: lazy.nvim
- **Main config**: `init.lua` (single-file kickstart approach)
- **Custom plugins**: `lua/custom/plugins/` directory
- **Plugin status**: Use `:Lazy` to view current plugin status and updates

## Key Plugin Architecture

### Core Plugins (from kickstart.nvim)
- **LSP**: nvim-lspconfig with Mason for automatic LSP installation
- **Completion**: nvim-cmp with LuaSnip for snippets
- **Fuzzy Finder**: telescope.nvim with fzf-native
- **Treesitter**: nvim-treesitter for syntax highlighting
- **Git**: gitsigns.nvim for git integration
- **Formatting**: conform.nvim for code formatting

### Custom Plugins
- **Avante**: AI-powered coding assistant using Gemini API (`lua/custom/plugins/avante.lua`)
- **Blink**: Enhanced completion with friendly-snippets (`lua/custom/plugins/blink.lua`)
- **Diffview**: Advanced Git diff visualization (`lua/custom/plugins/diffview.lua`)
- **Custom keymaps**: Terminal and buffer management (`lua/custom/plugins/keymaps.lua`)

## Language Server Configuration

### Supported Languages
- **C/C++**: clangd with enhanced features (background-index, clang-tidy integration)
- **CMake**: neocmakelsp for CMake project support
- **Lua**: lua_ls with Neovim-specific configuration

### LSP Tools via Mason
- `stylua` - Lua formatter
- `codelldb` - C/C++ debugger
- `neocmakelsp` - CMake language server
- `clang-format` - C/C++ code formatter

## Key Keybindings

### Leader Key
- Leader key: `<Space>`

### Custom Keybindings
- `<leader>tt` - Open horizontal terminal split
- `jk` - Exit insert mode (alternative to Esc)
- `<leader>x` - Delete current buffer
- `<space><space>x` - Reload current configuration

### Git Workflow (Diffview)
- `<leader>gd` - Open Git diff view
- `<leader>gh` - View current file Git history
- `<leader>gH` - View project Git history
- `<leader>gc` - Close diff view
- `<leader>gf` - Toggle file panel

### Telescope Search
- `<leader>sf` - Search files
- `<leader>sg` - Live grep
- `<leader>sw` - Search current word
- `<leader>sh` - Search help
- `<leader>sn` - Search Neovim config files

### LSP Features
- `gd` - Go to definition (via Telescope)
- `gr` - Go to references
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>dd` - Display definition (hover)

## Configuration Customizations

### Editor Settings
- Tab width: 4 spaces (expandtab enabled)
- Auto-save: 3-second delay after text changes
- Encoding: UTF-8 with GB2312 fallback
- Folding: Treesitter-based with default unfold level 99

### Clipboard Integration
- Custom clipboard provider support via `clipboard-provider`
- Tmux integration for clipboard operations

### Auto-save Feature
- Automatic file saving after 3 seconds of inactivity
- Only saves modified, writable files with proper buffer types

## Development Workflow

### Plugin Updates
```bash
# Update all plugins
:Lazy update

# Check plugin status
:Lazy
```

### LSP Management
```bash
# Install/manage LSP servers
:Mason

# Check LSP status
:LspInfo

# Check health
:checkhealth
```

### Debugging
- Uses `codelldb` for C/C++ debugging
- Debug configuration available via kickstart debug plugin

## File Structure

```
~/.config/nvim/
├── init.lua              # Main configuration (kickstart-based)
├── lazy-lock.json        # Plugin version lock file
├── lua/
│   ├── kickstart/        # Kickstart base plugins
│   └── custom/
│       └── plugins/      # Custom plugin configurations
│           ├── init.lua  # Custom settings and auto-save
│           ├── avante.lua    # AI assistant
│           ├── blink.lua     # Enhanced completion
│           ├── diffview.lua  # Git diff viewer
│           ├── gitsigns.lua  # Git integration
│           └── keymaps.lua   # Custom keybindings
└── doc/                  # Documentation
```

## Important Notes

- This configuration includes Chinese language support with encoding fallbacks
- Auto-save is enabled with 3-second delay - files are automatically saved
- The configuration uses Nerd Font icons (`vim.g.have_nerd_font = true`)
- Avante plugin requires `GEMINI_API_KEY` environment variable for AI features
- Custom clipboard provider integration for enhanced copy/paste operations