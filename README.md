# Dotfiles

My personal macOS development environment, managed with a custom `dot` CLI, GNU Stow, and Homebrew.

This repository originally started from Dillon Mulroy's dotfiles and has since diverged into my own setup.

## Overview

This repository contains the configuration and tooling I use to set up and maintain my development environment.

The main idea is:

```text
~/.dotfiles/home/... → GNU Stow → ~/...
```

The files inside `~/.dotfiles/home` are the source of truth.

GNU Stow creates the corresponding symlinks in my home directory.

For example:

```text
~/.dotfiles/home/.config/nvim
        ↓
      Stow
        ↓
~/.config/nvim
```

Structural configuration changes should be made inside this repository and then applied with:

```bash
dot stow
```

The repository also contains a `dot` CLI for installation, package management, diagnostics, updates, and other maintenance tasks.

## Key Features

- GNU Stow for managing configuration symlinks
- Homebrew for package and application installation
- Custom `dot` CLI for setup and maintenance
- Fish as the interactive shell
- Neovim as the primary editor
- Git and jj-aware tooling
- Separate base and work package configuration
- Environment diagnostics through `dot doctor`
- AI tooling integrated into the development environment

## Quick Start

```bash
# Clone the repository
git clone https://github.com/MobC0des/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Full setup
./dot init

# Or skip optional SSH/font setup
./dot init --skip-ssh --skip-font
```

After installation, the `dot` command is available for ongoing management.

Running it without arguments shows the available commands:

```bash
dot
```

## Repository Structure

```text
~/.dotfiles/
├── dot                 # Main CLI
├── AGENTS.md           # Repository guidance for AI/coding agents
├── home/               # Configuration source files, stowed into ~
│   ├── .config/
│   │   ├── fish/       # Fish shell configuration
│   │   ├── git/        # Git configuration
│   │   ├── nvim/       # Neovim configuration
│   │   └── ...
│   └── .ideavimrc      # IntelliJ IDEA Vim configuration
├── packages/
│   ├── bundle          # Base Brewfile
│   └── bundle.work     # Work-specific packages
└── README.md
```

## Configuration Ownership

The `home/` directory is the source of truth for configuration managed by Stow.

For example, Neovim lives here:

```text
~/.dotfiles/home/.config/nvim
```

and is exposed to Neovim here:

```text
~/.config/nvim
```

through symlinks created by GNU Stow.

This matters when making structural changes.

For normal edits to an existing symlinked file, editing through either path ultimately changes the source file.

For adding, deleting, renaming, or moving configuration files, make the change inside `.dotfiles` and then run:

```bash
dot stow
```

This avoids creating unmanaged files inside `~/.config`.

## Neovim

The Neovim configuration is Lua-based and managed with `lazy.nvim`.

Its personal configuration namespace is:

```text
lua/mobc0des/
```

The setup is primarily focused on TypeScript and JavaScript development.

Core parts of the editor include:

- Neovim LSP
- Mason
- `typescript-tools.nvim`
- Blink completion
- LuaSnip
- Conform formatting
- Treesitter
- Telescope
- Oil
- UFO folding
- WhichKey
- Catppuccin Macchiato
- JJ/Git-aware VCS tooling

More detailed Neovim-specific documentation lives in:

```text
home/.config/nvim/AGENTS.md
```

## The `dot` CLI

The `dot` command manages installation and maintenance of the environment.

## Installation

### `dot init`

Runs the initial environment setup.

```bash
dot init
```

Optional flags:

```bash
# Skip SSH key generation
dot init --skip-ssh

# Skip font installation
dot init --skip-font

# Skip both
dot init --skip-ssh --skip-font
```

The setup process includes:

1. Installing Homebrew if required
2. Installing packages from the Brewfiles
3. Creating configuration symlinks with GNU Stow
4. Installing the Bun runtime
5. Installing pi through the Vite+ tool registry
6. Optionally generating an SSH key for GitHub
7. Optionally installing the configured font
8. Setting up Fish and its plugins

## Maintenance

### `dot update`

Updates the development environment.

```bash
dot update
```

This includes:

- pulling the latest dotfiles changes
- detecting whether the repository is using jj or Git
- updating Homebrew packages
- re-stowing configuration files
- updating pi and its configured packages
- running the configured pi skill synchronization

### `dot doctor`

Runs environment diagnostics.

```bash
dot doctor
```

Checks include:

- Homebrew installation
- essential development tools
- pi and development tooling
- Fish configuration
- PATH configuration
- broken symlinks
- missing dependencies

### `dot check-packages`

Shows the installation status of packages declared in the Brewfiles.

```bash
dot check-packages
```

### `dot retry-failed`

Retries packages that failed during installation.

```bash
dot retry-failed
```

## Fish Shell Benchmarking

### `dot benchmark-shell`

Benchmarks Fish startup performance.

```bash
# Run 10 benchmarks
dot benchmark-shell

# Run a custom number of benchmarks
dot benchmark-shell -r 20

# Show individual timings
dot benchmark-shell -v

# Combine options
dot benchmark-shell -r 15 -v
```

The benchmark includes:

- high-precision timing
- average startup time
- fastest and slowest runs
- timing range
- basic performance assessment
- profiling guidance when startup is slow

Example:

```text
=> Fish Shell Startup Benchmark Results

Configuration:
  Shell: fish
  Runs: 10
  Test: Empty script execution

Performance Results:
  Average time: 0.061 seconds
  Fastest time: 0.048 seconds
  Slowest time: 0.078 seconds
  Time range:   0.030 seconds

Performance Assessment:
✓ Good startup performance
```

## Utility Commands

### `dot completions`

Generates Fish completions for the `dot` CLI.

```bash
dot completions
```

The generated completions include:

- commands and subcommands
- command options
- package names where relevant

### `dot edit`

Opens the dotfiles repository using `$EDITOR`.

```bash
dot edit
```

### `dot stow`

Re-applies configuration symlinks.

```bash
dot stow
```

This uses GNU Stow to map files from:

```text
~/.dotfiles/home/
```

into:

```text
~/
```

Run it after structural changes such as:

- adding a configuration file
- deleting a configuration file
- renaming a configuration file
- moving configuration directories

### `dot link`

Makes the `dot` command globally available.

```bash
dot link
```

### `dot unlink`

Removes the global `dot` command link.

```bash
dot unlink
```

## Package Management

Package management uses two Brewfiles:

```text
packages/bundle
packages/bundle.work
```

The base bundle contains packages used across machines, while the work bundle contains additional work-specific tooling.

### Listing Packages

```bash
dot package list
dot package list base
dot package list work
```

### Adding Packages

```bash
# Add a formula to the base bundle
dot package add git

# Add a cask to the base bundle
dot package add docker cask

# Add a formula to the work bundle
dot package add kubectl brew work
```

### Updating Packages

```bash
# Update all installed packages
dot package update

# Update one package
dot package update git

# Update the base bundle
dot package update all base

# Update the work bundle
dot package update all work
```

### Removing Packages

```bash
# Remove a package
dot package remove git

# Remove a package specifically from the base bundle
dot package remove docker base
```

## Package Files

### `packages/bundle`

Contains the base development environment.

This includes tools such as:

- Neovim
- Fish
- Git
- ripgrep
- fd
- fzf
- development applications
- CLI tooling

### `packages/bundle.work`

Contains tooling needed specifically for work environments.

This can include things such as:

- cloud tooling
- Kubernetes tooling
- enterprise development utilities

## Configuration Areas

### Fish

Fish configuration contains shell setup, functions, environment configuration, and plugin management.

```text
home/.config/fish/
```

### Git

Git configuration lives under:

```text
home/.config/git/
```

It includes personal Git settings as well as conditional configuration where required.

### Neovim

Neovim configuration lives under:

```text
home/.config/nvim/
```

The entry point is:

```text
home/.config/nvim/init.lua
```

which loads the personal namespace:

```lua
require("mobc0des")
```

## Architecture

### GNU Stow

GNU Stow manages the relationship between repository files and files visible from the home directory.

The repository contains:

```text
home/.config/nvim/init.lua
```

while Neovim sees:

```text
~/.config/nvim/init.lua
```

This allows configuration to remain version-controlled without copying files manually into the home directory.

### Modular Configuration

Each major tool owns its own configuration area.

For example:

```text
home/.config/fish/
home/.config/git/
home/.config/nvim/
home/.config/tmux/
```

This keeps shell, editor, version-control, and terminal configuration separate.

### Git and jj

Some tooling detects whether a project is using Git or jj and behaves appropriately.

The Neovim statusline and repository tooling also support a JJ-first workflow with Git fallback where appropriate.

## Environment Setup

### Prerequisites

- macOS
- internet connection
- terminal access

Both Intel and Apple Silicon Macs are supported by the setup.

## First-Time Setup

Clone the repository:

```bash
git clone https://github.com/MobC0des/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Run the installer:

```bash
./dot init
```

Restart the terminal or reload Fish:

```bash
source ~/.config/fish/config.fish
```

Then verify the environment:

```bash
dot doctor
```

## Customisation

### Adding Packages

The preferred way to add packages is through the `dot` CLI.

```bash
dot package add new-tool
dot package add new-app cask
dot package add work-tool brew work
```

Packages can also be added manually by editing:

```text
packages/bundle
```

or:

```text
packages/bundle.work
```

For example:

```ruby
brew "new-tool"
cask "new-app"
```

Then apply the installation:

```bash
dot init
```

or use Homebrew directly:

```bash
brew bundle --file=./packages/bundle
```

## Modifying Configuration

For normal configuration changes:

1. Edit the relevant file under `home/`
2. Test the change
3. Commit it to the repository

For structural changes:

1. Add, remove, rename, or move the file under `home/`
2. Run:

   ```bash
   dot stow
   ```

3. Verify the corresponding file or symlink under `~/`
4. Test the application using that configuration

The repository should remain the source of truth rather than `~/.config`.

## Troubleshooting

### `dot` Command Not Found

Reload Fish:

```bash
source ~/.config/fish/config.fish
```

Or temporarily add the repository to the path:

```bash
export PATH="$HOME/.dotfiles:$PATH"
```

### Package Installation Failures

Check the package state:

```bash
dot check-packages
```

Retry failed packages:

```bash
dot retry-failed
```

### Broken or Incorrect Symlinks

Run diagnostics:

```bash
dot doctor
```

Then re-apply Stow:

```bash
dot stow
```

If Stow reports a conflict, check whether a real unmanaged file exists at the target path before deleting or replacing anything.

The source file inside `.dotfiles/home` should remain the source of truth.

### pi Installation

Ensure Vite+ is installed:

```bash
curl -fsSL https://vite.plus | bash
```

Then install pi:

```bash
vp install -g @mariozechner/pi-coding-agent
```

## Getting Help

Show the general `dot` help:

```bash
dot help
```

Show help for a specific command:

```bash
dot <command> --help
```

Run environment diagnostics:

```bash
dot doctor
```

Failed package logs are stored under files matching:

```text
packages/failed_packages_*.txt
```

## Testing Changes

After modifying configuration, verify the relevant tool rather than assuming the configuration is correct.

Useful repository-level checks include:

```bash
dot doctor
dot check-packages
```

For structural configuration changes:

```bash
dot stow
```

For Neovim changes, restart Neovim and verify the affected behaviour directly.

Examples include:

- LSP attachment
- completion
- formatting
- Telescope
- Oil
- folding
- keymaps
- diagnostics

## Selective Installation

Optional parts of setup can be skipped:

```bash
dot init --skip-ssh --skip-font
```

Check what remains missing:

```bash
dot check-packages
```

Work packages can also be installed separately:

```bash
brew bundle --file=./packages/bundle.work
```

## Shell Completions

Generate Fish completions with:

```bash
dot completions
```

The completions include commands, options, and package names where supported.

## License

This repository is primarily for my personal use.

Feel free to use it as inspiration or adapt parts of it for your own environment.

## Acknowledgments

- [Dillon Mulroy](https://github.com/dmmulroy), whose dotfiles were the original starting point for this repository
- [GNU Stow](https://www.gnu.org/software/stow/) for symlink management
- [Homebrew](https://brew.sh/) for package management
- pi for AI-assisted development tooling
- The wider dotfiles community for ideas and inspiration
