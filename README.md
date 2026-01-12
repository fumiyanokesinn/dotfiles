# Dotfiles

GNU Stowで管理する個人用dotfiles

## 内容

- **wezterm**: WezTermターミナルエミュレータの設定
- **fish**: Fish shellの設定（fzf統合付き）
- **starship**: Starshipプロンプトの設定（ミニマルな2行構成）
- **git**: Gitの設定とグローバルgitignore
- **nvim**: Neovimの設定（LSP、Treesitter、lazy.nvim）
- **kitty**: Kittyターミナルエミュレータの設定

## 必要なもの

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Fish Shell](https://fishshell.com/)
- [Starship](https://starship.rs/)
- [Neovim](https://neovim.io/) (0.11+)
- [WezTerm](https://wezfurlong.org/wezterm/) または [Kitty](https://sw.kovidgoyal.net/kitty/)

### GNU Stowのインストール

```bash
brew install stow
```

## インストール

### リポジトリのクローン

```bash
git clone <your-repo-url> ~/Workspace/dotfiles
cd ~/Workspace/dotfiles
```

### 既存の設定のバックアップ

インストール前に、既存の設定をバックアップしてください：

```bash
mkdir -p ~/config_backup
mv ~/.config/fish ~/config_backup/fish_backup
mv ~/.config/starship.toml ~/config_backup/starship.toml.backup
mv ~/.gitconfig ~/config_backup/gitconfig.backup
mv ~/.config/git ~/config_backup/git_backup
mv ~/.config/nvim ~/config_backup/nvim_backup
mv ~/.config/kitty ~/config_backup/kitty_backup
```

### すべての設定をインストール

```bash
cd ~/Workspace/dotfiles
stow wezterm fish starship git nvim kitty
```

### 特定の設定のみインストール

```bash
# fishとstarshipのみインストール
stow fish starship

# weztermのみインストール
stow wezterm
```

## アンインストール

シンボリックリンクを削除する場合：

```bash
cd ~/Workspace/dotfiles
stow -D wezterm fish starship git nvim kitty
```

## ディレクトリ構造

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

## 機能

### Fish Shell
- fzf統合による履歴検索（Ctrl+R）
- ディレクトリ変更時の自動`ls`実行
- Fisherプラグインマネージャー
- goenv統合

### Starship
- 超ミニマルな2行プロンプト
- 1行目にディレクトリ表示
- コマンド実行時間トラッキング
- カスタムカーソルシンボル

### WezTerm
- デフォルトシェルがFish
- JetBrainsMono Nerd Font
- Tokyo Nightカラースキーム
- 透過背景（0.92不透明度）
- Vim風ペインナビゲーション（Cmd+h/j/k/l）
- ペイン分割（Cmd+dで水平分割、Cmd+Shift+dで垂直分割）

### Neovim
- lazy.nvimプラグインマネージャー
- LSPサポート（gopls、ts_ls）
- Treesitterシンタックスハイライト
- Snacks.nvimによるファイルナビゲーション
- blink.cmpによる補完
- Tokyo Nightテーマ（透過背景付き）
- gitsignsによるGit統合

### Kitty
- WezTermと類似の設定
- Powerlineタブバースタイル
- 背景画像サポート
- 20000行のスクロールバック

## 新しい設定の追加方法

1. `~/Workspace/dotfiles/`に新しいディレクトリを作成
2. その中にホームディレクトリの構造を再現
3. 設定ファイルを追加
4. dotfilesルートから`stow <ディレクトリ名>`を実行

例：

```bash
cd ~/Workspace/dotfiles
mkdir -p tmux/.config/tmux
cp ~/.config/tmux/tmux.conf tmux/.config/tmux/
stow tmux
```

## ライセンス

MIT
