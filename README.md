# Dotfiles

Personal dotfiles managed with GNU Stow.

## Contents

- **wezterm**: WezTerm terminal emulator configuration
- **fish**: Fish shell configuration with fzf integration
- **starship**: Starship prompt configuration (minimal 2-line setup)
- **git**: Git configuration and global gitignore
- **nvim**: Neovim configuration with LSP, Treesitter, and lazy.nvim
- **kitty**: Kitty terminal emulator configuration

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Fish Shell](https://fishshell.com/)
- [Starship](https://starship.rs/)
- [Neovim](https://neovim.io/) (0.11+)
- [WezTerm](https://wezfurlong.org/wezterm/) or [Kitty](https://sw.kovidgoyal.net/kitty/)

### Install GNU Stow

```bash
brew install stow
```

## Installation

### Clone the repository

```bash
git clone <your-repo-url> ~/Workspace/dotfiles
cd ~/Workspace/dotfiles
```

### Backup existing configurations

Before installing, backup your existing configurations:

```bash
mkdir -p ~/config_backup
mv ~/.config/fish ~/config_backup/fish_backup
mv ~/.config/starship.toml ~/config_backup/starship.toml.backup
mv ~/.gitconfig ~/config_backup/gitconfig.backup
mv ~/.config/git ~/config_backup/git_backup
mv ~/.config/nvim ~/config_backup/nvim_backup
mv ~/.config/kitty ~/config_backup/kitty_backup
```

### Install all configurations

```bash
cd ~/Workspace/dotfiles
stow wezterm fish starship git nvim kitty
```

### Install specific configurations

```bash
# Install only fish and starship
stow fish starship

# Install only wezterm
stow wezterm
```

## Uninstallation

To remove the symlinks:

```bash
cd ~/Workspace/dotfiles
stow -D wezterm fish starship git nvim kitty
```

## Structure

```
dotfiles/
├── wezterm/
│   └── .config/
│       └── wezterm/
│           └── wezterm.lua
├── fish/
│   └── .config/
│       └── fish/
│           ├── config.fish
│           ├── fish_plugins
│           └── ...
├── starship/
│   └── .config/
│       └── starship.toml
├── git/
│   ├── .gitconfig
│   └── .config/
│       └── git/
│           └── ignore
├── nvim/
│   └── .config/
│       └── nvim/
│           └── ...
└── kitty/
    └── .config/
        └── kitty/
            └── ...
```

## Features

### Fish Shell
- fzf integration for history search (Ctrl+R)
- Auto `ls` on directory change
- Fisher plugin manager
- goenv integration

### Starship
- Ultra minimal 2-line prompt
- Directory display on first line
- Command duration tracking
- Custom cursor symbols

### WezTerm
- Fish shell as default
- JetBrainsMono Nerd Font
- Tokyo Night color scheme
- Transparent background (0.92 opacity)
- Vim-like pane navigation (Cmd+h/j/k/l)
- Split panes (Cmd+d horizontal, Cmd+Shift+d vertical)

### Neovim
- lazy.nvim plugin manager
- LSP support (gopls, ts_ls)
- Treesitter syntax highlighting
- Snacks.nvim for file navigation
- blink.cmp for completion
- Tokyo Night theme with transparent background
- Git integration with gitsigns

### Kitty
- Similar configuration to WezTerm
- Powerline tab bar style
- Background image support
- 20000 lines scrollback

## Adding New Configurations

1. Create a new directory in `~/Workspace/dotfiles/`
2. Mirror the home directory structure inside it
3. Add your configuration files
4. Run `stow <directory-name>` from the dotfiles root

Example:

```bash
cd ~/Workspace/dotfiles
mkdir -p tmux/.config/tmux
cp ~/.config/tmux/tmux.conf tmux/.config/tmux/
stow tmux
```

## License

MIT
