# Neovim configuration

My personal Neovim setup, managed as part of this [chezmoi dotfiles repository](../../../README.md). It uses Lua, [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management, and a customized [Base46](https://github.com/NvChad/base46) theme.

> [!IMPORTANT]
> This configuration targets **Neovim Nightly**, not the stable release. It uses APIs and built-in runtime packages from the development version, so compatibility with stable Neovim is not guaranteed. Nightly updates can introduce breaking changes.

## Requirements

- **Neovim Nightly** (`nvim --version` should identify a development build).
- `git` to bootstrap `lazy.nvim` and install plugins.
- `ripgrep` (`rg`) for file and text searches through fzf-lua.
- A terminal and font with Nerd Font glyph support for icons.
- A C compiler and the [Tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli) for parser builds and updates.
- Language servers, formatters, linters, and debug adapters for the languages you use. They are not all installed automatically; use `:Mason` for supported tools or install them through your system package manager.

The dotfiles package manifest already declares `neovim-nightly`, `git`, `ripgrep`, `tree-sitter-cli`, Nerd Fonts, and `delve` for Arch Linux. Some features also rely on external executables such as `stylua`, `biome`, `eslint_d`, `phpcs`, `sqlfluff`, or `pg_format` when editing the corresponding file types.

## Installation

When using the complete dotfiles repository, follow the [root installation instructions](../../../README.md). chezmoi maps `home/dot_config/nvim/` to `~/.config/nvim/`.

To use just the editor configuration, copy that directory to `~/.config/nvim/` (back up any existing configuration first):

```bash
git clone https://github.com/notrodans/dotfiles.git
mkdir -p ~/.config
cp -R dotfiles/home/dot_config/nvim ~/.config/nvim
nvim
```

On the first start, `init.lua` clones the stable branch of `lazy.nvim` if necessary, and lazy.nvim installs the declared plugins. Tree-sitter parser installation or updates may require the compiler and CLI mentioned above. Restart Neovim after the initial setup if plugins request it.

Check the installation with `:Lazy`, `:checkhealth`, and `:Mason`. `:Lazy sync` updates or installs plugins, while the checked-in `lazy-lock.json` records their resolved revisions.

## Features

- **Editing:** Tree-sitter highlighting and text objects, completion through `blink.cmp`, snippets through LuaSnip, autopairs, surround operations, and formatting through Conform.
- **Navigation:** fzf-lua pickers for files, text, buffers, diagnostics, and LSP symbols; Oil for file management; a custom buffer/tab line.
- **Language tooling:** Neovim's built-in LSP client with configured servers for Lua, Java, Go, TypeScript/JavaScript, web languages, and more; Mason for managing supported developer tools; nvim-lint for selected file types.
- **Debugging:** nvim-dap with Go integration through `nvim-dap-go` and Delve.
- **Workspace:** resession-based sessions with autosave and integrations for Oil and the buffer line.
- **Appearance:** Base46 themes, theme picker, Nerd Font icons, and custom terminal layouts.

Features requiring a language server or external executable become available only when the matching tool is installed and configured for the project.

## Keybindings

The leader key is **Space**. This is a selection of the mappings; plugin-specific mappings are defined in `lua/plugins/`.

| Keys | Action |
| --- | --- |
| `jj` (insert mode) | Return to normal mode |
| `Ctrl-s` | Save current file |
| `Ctrl-h/j/k/l` (normal mode) | Move between windows |
| `Ctrl-n` | Toggle Oil file browser |
| `Space ff` | Find files |
| `Space fg` | Live grep |
| `Space fb` | Find open buffers |
| `Space fr` | Resume previous picker |
| `Space fk` | Search keymaps |
| `Space fd` / `Space fi` | LSP definitions / implementations |
| `Space dd` / `Space dw` | Buffer / workspace diagnostics |
| `Space fm` | Format current buffer |
| `Space th` | Open theme picker |
| `Space ws` / `Space wl` / `Space wd` | Save / load / delete workspace session |
| `]b` / `[b` | Next / previous buffer |
| `qb` | Close buffer |
| `Alt-v` / `Alt-h` / `Alt-i` | Vertical / horizontal / floating terminal |
| `F5` / `F10` / `F11` / `F12` | Debug continue / step over / step into / step out |
| `Space Db` | Toggle breakpoint |

Some terminals intercept `Alt` or function keys, so those bindings may need terminal-specific configuration.

## Layout

| Path | Purpose |
| --- | --- |
| `init.lua` | Bootstrap and startup sequence |
| `lua/plugins/` | Active lazy.nvim plugin specifications |
| `lua/configs/` | Configuration shared by plugin specifications |
| `lua/modules/` | Custom editor features and UI behavior |
| `lua/mappings.lua` | General keybindings |
| `lua/options.lua` | Editor options |
| `lua/autocmds.lua` | Autocommands |
| `lua/nvconfig.lua` | Base46 theme and UI configuration |
| `lua/themes/` | Custom themes |
| `lua/plugins_archived/` | Inactive plugin configurations |
| `lazy-lock.json` | Plugin revision lockfile |

## Customization

- Add or modify plugins in `lua/plugins/` and run `:Lazy sync`.
- Edit general keybindings in `lua/mappings.lua` and options in `lua/options.lua`.
- Change the default Base46 theme in `lua/nvconfig.lua`, or use `Space th` interactively.
- Adjust LSP server settings in `lua/configs/lspconfig.lua`; formatter and linter mappings live in `lua/plugins/conform.lua` and `lua/plugins/lint.lua`.

The configuration enables project-local Neovim configuration (`exrc`), so review `.nvim.lua` files in projects before trusting and executing them.
