# DOTFILES

Personal macOS development environment managed with GNU Stow, Homebrew, Fish, mise, and a custom `dot` CLI.

The setup is intentionally small. Keep ownership clear and do not introduce new tools or abstractions unless there is a concrete need for them.

## ARCHITECTURE

```text
macOS
├── Homebrew      → machine-level apps + CLI tools
├── GNU Stow      → config placement
├── Fish          → interactive shell
├── mise          → runtime versions
├── direnv        → project environment activation
├── Ghostty       → terminal
├── Zed           → primary project editor
├── Helix         → terminal editor / $EDITOR
├── Git           → version control
├── OrbStack      → containers/Linux
└── AI
    ├── ChatGPT   → reasoning, investigation, architecture, review
    ├── Pi        → implementation
    └── Claude    → implementation
```

Each tool should have one clear responsibility.

Avoid multiple tools owning the same concern.

## STRUCTURE

```text
.dotfiles/
├── dot                         # Custom setup/maintenance CLI
├── home/
│   ├── .config/
│   │   ├── fish/               # Shell config
│   │   ├── ghostty/            # Terminal config
│   │   ├── git/                # Git + conditional work identity
│   │   ├── helix/              # Terminal editor
│   │   ├── herdr/              # Window/workspace management
│   │   ├── mise/               # Runtime policy
│   │   ├── ripgrep/            # rg config
│   │   └── starship.toml       # Prompt
│   ├── .local/bin/             # Personal scripts
│   └── .pi/                    # Pi config/extensions/theme
└── packages/
    ├── bundle                  # Base Homebrew bundle
    └── bundle.work             # Work additions
```

`home/` mirrors `$HOME`.

GNU Stow creates the real files in `$HOME` as symlinks back into this repo.

For example:

```text
~/.dotfiles/home/.config/helix
        ↓
      Stow
        ↓
~/.config/helix
```

## OWNERSHIP

```text
machine apps/tools   → Homebrew
config placement     → GNU Stow
shell behaviour      → Fish
runtime versions     → mise
project environment  → direnv
global JS CLIs       → ~/.npm-global
project dependencies → project package manager
editor config        → Zed / Helix
containers/Linux     → OrbStack
```

Do not blur these boundaries without a concrete reason.

## WHERE TO LOOK

| Task | Location |
| --- | --- |
| Add machine package | `packages/bundle` |
| Shell startup config | `home/.config/fish/config.fish` |
| Tool shell integration | `home/.config/fish/conf.d/<tool>.fish` |
| Shell completion | `home/.config/fish/completions/` |
| Runtime defaults | `home/.config/mise/config.toml` |
| Git config | `home/.config/git/config` |
| Work Git identity | `home/.config/git/work_config` |
| Helix config | `home/.config/helix/config.toml` |
| Helix language config | `home/.config/helix/languages.toml` |
| Ghostty config | `home/.config/ghostty/config` |
| Starship prompt | `home/.config/starship.toml` |
| Herdr config | `home/.config/herdr/config.toml` |
| Pi config | `home/.pi/agent/` |
| Personal scripts | `home/.local/bin/` |

## STOW

Structural config changes belong in this repository.

Do not edit Stow-managed files under `~/.config` directly.

Edit:

```text
~/.dotfiles/home/...
```

then run:

```bash
dot stow
```

Verify the resulting symlink and the tool behaviour afterwards.

## FISH

Fish is intentionally small.

It should mainly handle:

- core environment variables
- PATH setup
- Homebrew setup
- mise activation
- Bun availability
- OrbStack integration
- Starship initialization
- zoxide initialization
- Catppuccin-related config

Fish should not:

- install packages automatically
- manage project dependencies
- contain a large Git alias framework
- contain a worktree framework
- duplicate functionality already provided by another tool

Prefer small `conf.d/*.fish` files for tool integration.

## RUNTIMES

mise owns runtime versions.

Global config:

```toml
[settings]
activate_shims = false

[tools]
node = "26.10.0"
```

`activate_shims = false` is deliberate.

Do not re-enable global mise shims without investigating the PATH behaviour first.

Projects that need a specific runtime should own a `mise.toml`.

Example:

```toml
[tools]
node = "26.5.0"
```

The model is:

```text
default runtime → mise global config
project runtime → project mise.toml
```

Do not use Homebrew, Vite+, or shell scripts to own Node versions.

## JAVASCRIPT TOOLING

Intentional global JavaScript CLIs live in:

```text
~/.npm-global
```

Current examples include:

- pnpm
- Pi
- Claude Code
- HubSpot CLI
- Prettier
- ccusage
- TypeScript
- TypeScript language server
- Tailwind CSS language server
- VS Code language servers

These are global tools.

Project dependencies still belong to the project.

Respect the project's existing package manager:

```text
package-lock.json → npm
bun.lock          → Bun
pnpm-lock.yaml    → pnpm
```

Do not change package manager without a project-level reason.

## EDITORS

### Zed

Primary editor for normal project work and exploration.

### Helix

Terminal editor and default `$EDITOR` / `$VISUAL`.

```fish
set -gx EDITOR hx
set -gx VISUAL hx
```

Helix uses Catppuccin Macchiato.

JavaScript, JSX, TypeScript, and TSX formatting currently calls `prettier` from `PATH`.

Do not assume Prettier is project-local when changing Helix formatter behaviour.

## GIT

Git uses Helix:

```gitconfig
[core]
    editor = "hx"
```

The default Git identity is personal.

Repositories under:

```text
~/Sites/
```

use the work identity through `includeIf` and:

```text
~/.config/git/work_config
```

Do not add Fish-dependent Git aliases or destructive convenience aliases without a clear need.

## PI

Dotfiles can own Pi configuration such as:

- extensions
- MCP config
- themes

Reusable personal skills are installed separately into:

```text
~/.pi/agent/skills
```

Do not add skill symlinks back into the dotfiles repo.

Personal reusable skills and work-specific skills have separate ownership.

## HOMEBREW

Homebrew owns machine-level tools and applications.

The base bundle is deliberately small.

Do not add formulae just because they may be useful later.

Add packages in response to an actual requirement.

This machine is Intel (`x86_64`) and Homebrew lives under:

```text
/usr/local
```

Avoid broad `brew bundle` or upgrade operations during routine config work.

Homebrew support for Intel may require source builds for newer packages, which can be slow and disruptive.

Prefer targeted package operations.

Homebrew does not own Node runtime versions.

## THEME

Catppuccin Macchiato is a deliberate constraint.

Keep it across tools where supported, including:

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

Do not replace the theme as part of unrelated cleanup.

## COMMANDS

```bash
dot init              # Initial setup
dot update            # Update managed tooling/config
dot doctor            # Health checks
dot stow              # Reapply Stow links
dot package add X     # Add/install a package
dot benchmark-shell   # Check Fish startup performance
dot gen-ssh-key       # Generate SSH key
```

Before changing behaviour in the `dot` CLI, inspect the implementation rather than relying on this summary.

## ANTI-PATTERNS

Do not:

- edit Stow-managed `~/.config/*` files directly
- reintroduce Neovim config
- reintroduce Vite+ runtime ownership
- reintroduce Fisher just for convenience
- make Homebrew own Node versions
- add large Fish alias/function frameworks
- add generated or runtime state to Stow
- put personal Pi skills back under dotfile ownership
- hardcode `$HOME`-specific absolute paths when a variable will work
- add infrastructure without a concrete requirement
- run broad Homebrew upgrades during unrelated changes

## WORKING STYLE

For non-trivial changes:

```text
understand
→ investigate
→ capture
→ spec
→ implement
→ review
→ verify
```

Investigate the current system before changing it.

Separate confirmed findings from assumptions.

Prefer small changes that can be understood and verified independently.

Do not treat generated code or agent output as authoritative.

## VERIFYING CHANGES

Verify the behaviour that actually changed.

Examples:

```bash
dot stow

which node
node --version
mise current

which prettier
prettier --version

echo $BAT_THEME

git config user.name
git config user.email

git diff --check
```

For project runtime changes, verify against a real project build or test rather than assuming runtime resolution is enough.

## PHILOSOPHY

Keep it small.

Keep ownership clear.

Prefer boring, understandable configuration over clever abstractions.

If a tool does not have a clear job, or another tool already owns that job, it probably does not belong here.
