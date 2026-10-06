# Dotfiles

My macOS development setup.

This repo started from Dillon Mulroy's dotfiles, but I've stripped a lot of that back and turned it into my own setup.

The main goal now is simple: keep the environment small, make ownership clear, and only keep tools I actually use and understand.

## How it works

Anything inside:

```text
~/.dotfiles/home
```

is managed with GNU Stow and linked into my home directory.

For example:

```text
~/.dotfiles/home/.config/helix
        ↓
      Stow
        ↓
~/.config/helix
```

If I change structural config, I make the change in this repo and then run:

```bash
dot stow
```

The repo also contains my `dot` CLI, which handles setup, package management, diagnostics and general maintenance.

## Setup

The current setup looks like this:

```text
macOS
├── Homebrew      → machine-level apps + CLI tools
├── GNU Stow      → config placement
├── Fish          → shell
├── mise          → runtime versions
├── direnv        → project env activation
├── Ghostty       → terminal
├── Zed           → main editor
├── Helix         → terminal editor / $EDITOR
├── Git           → version control
├── OrbStack      → containers/Linux
└── AI
    ├── ChatGPT   → reasoning, investigation, architecture, review
    ├── Pi        → implementation
    └── Claude    → implementation
```

The main thing I care about is that each tool has one job.

I don't want multiple tools trying to manage the same thing.

## Runtime management

mise owns my runtimes.

My default Node version is:

```toml
[settings]
activate_shims = false

[tools]
node = "26.10.0"
```

Projects can override that with their own `mise.toml`.

For example:

```toml
[tools]
node = "26.5.0"
```

So the model is:

```text
default runtime      → mise
project runtime      → mise.toml
project dependencies → project package manager
```

## Global JS tools

Global JavaScript CLIs live in:

```text
~/.npm-global
```

That currently includes things like:

- pnpm
- Pi
- Claude Code
- HubSpot CLI
- Prettier
- ccusage
- TypeScript
- language servers

These are tools I want available globally.

Project dependencies still belong to the project.

## Editors

### Zed

Zed is my main editor for project work.

### Helix

Helix is my terminal editor and is also used for:

```text
$EDITOR
$VISUAL
```

It uses Catppuccin Macchiato and formats JavaScript/TypeScript through Prettier.

## Fish

Fish is intentionally small now.

It mainly handles:

- environment variables
- mise activation
- Starship
- Homebrew
- Bun
- OrbStack
- PATH setup
- zoxide
- Catppuccin shell config

It does not install packages or try to manage project tooling.

## Theme

I use Catppuccin Macchiato across the setup.

That includes:

- Ghostty
- Fish
- Starship
- Helix
- bat
- Pi

For bat:

```fish
set -gx BAT_THEME "Catppuccin Macchiato"
```

## Homebrew

Homebrew owns machine-level tools and apps.

The bundle is deliberately small.

Current CLI tools include:

```text
bat
btop
direnv
fd
fish
fzf
gh
helix
herdr
jq
ripgrep
shellcheck
starship
stow
zoxide
```

Apps include:

```text
Ghostty
OrbStack
Raycast
Zed
Geist Mono
```

Project package managers still depend on the project.

For example:

```text
package-lock.json → npm
bun.lock          → Bun
pnpm-lock.yaml    → pnpm
```

## Git

Git uses Helix as the editor:

```gitconfig
[core]
    editor = "hx"
```

My personal Git identity is the default.

Anything under:

```text
~/Sites/
```

uses my Blend work identity through `includeIf`.

## Pi skills

Pi config, themes and extensions can live in the dotfiles.

Reusable skills do not.

Those are installed separately into:

```text
~/.pi/agent/skills
```

That keeps skill syncing separate from the dotfiles repo.

Work-specific skills are also kept separate.

## Making changes

For config changes:

```bash
dot stow
```

Then I verify the thing I actually changed.

Examples:

```bash
which node
mise current
echo $BAT_THEME
git config user.email
```

## Philosophy

Keep it small.

Keep ownership clear.

Don't add tools just because they look useful.

If something does not have a clear job, or another tool already owns that job, it probably does not belong here.
