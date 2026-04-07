# Dotfiles

GNU Stowで管理する個人用dotfiles

## 内容

- **fish**: Fish shellの設定（fzf統合付き）
- **starship**: Starshipプロンプトの設定（ミニマルな2行構成）
- **git**: Gitの設定とグローバルgitignore
- **nvim**: Neovimの設定（LSP、Treesitter、lazy.nvim）
- **kitty**: Kittyターミナルエミュレータの設定
- **claude**: Claude Codeの設定（CLAUDE.md、MCP、エージェント、権限設定）
- **vscode**: VSCodeの設定（settings.json、keybindings.json、拡張機能リスト）
- **raycast**: Raycastの設定（.rayconfig エクスポート、plist）
- **gh**: GitHub CLIの設定（config.yml）
- **npm**: npm/pnpmの設定（.npmrc）
- **Brewfile**: Homebrewパッケージ一覧（brew, cask, フォント）
- **macos.sh**: macOSシステム設定（Dock, トラックパッド, ダークモード等）

## 必要なもの

- [GNU Stow](https://www.gnu.org/software/stow/)
- [Fish Shell](https://fishshell.com/)
- [Starship](https://starship.rs/)
- [Neovim](https://neovim.io/) (0.11+)
- [Kitty](https://sw.kovidgoyal.net/kitty/)

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
./install.sh
```

インストールスクリプトが以下を自動で行います：
- Stowパッケージ（fish, starship, git, nvim, kitty, cspell）のシンボリックリンク作成
- VSCode設定のシンボリックリンク作成 + 拡張機能インストール
- Claude Code、gh CLI、npmrc のシンボリックリンク作成
- Homebrewパッケージのインストール（Brewfile）
- Raycast設定のインポート（.rayconfig）
- macOSシステム設定の適用（確認あり）

### 特定の設定のみインストール

```bash
# Stowパッケージ（fish, starship等）
stow fish starship

# VSCode（パスにスペースがあるため--target指定）
stow --no-folding -t "$HOME/Library/Application Support/Code/User" vscode

# Claude Code（install.shのClaude部分を実行、または手動でシンボリックリンク）
ln -s ~/Workspace/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
```

## アンインストール

```bash
cd ~/Workspace/dotfiles

# Stowパッケージ
stow -D fish starship git nvim kitty cspell

# VSCode
stow -D -t "$HOME/Library/Application Support/Code/User" vscode

# Claude Code
rm ~/.claude/CLAUDE.md ~/.claude/.mcp.json ~/.claude/.claude/settings.local.json
rm ~/.claude/agents/review-layout.md ~/.claude/agents/slack-communicator.md
```

## ディレクトリ構造

```
dotfiles/
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
├── kitty/
│   └── .config/
│       └── kitty/
│           └── ...
├── claude/                  # シンボリックリンク（install.sh経由）
│   ├── CLAUDE.md            #   -> ~/.claude/CLAUDE.md
│   ├── .mcp.json            #   -> ~/.claude/.mcp.json
│   ├── agents/              #   -> ~/.claude/agents/*.md
│   │   ├── review-layout.md
│   │   └── slack-communicator.md
│   └── .claude/
│       └── settings.local.json  # -> ~/.claude/.claude/settings.local.json
├── vscode/                  # Stow --target（install.sh経由）
│   ├── settings.json        #   -> ~/Library/Application Support/Code/User/
│   ├── keybindings.json
│   └── extensions.txt       #   拡張機能リスト（参照用）
├── raycast/                 # Raycast設定（install.shでインポート）
│   ├── Raycast.rayconfig    #   完全エクスポート（スニペット、クイックリンク等含む）
│   └── com.raycast.macos.plist  # plist設定のバックアップ
├── gh/                      # GitHub CLI（install.sh経由）
│   └── .config/gh/
│       └── config.yml       #   -> ~/.config/gh/config.yml
├── npm/                     # npm/pnpm（install.sh経由）
│   └── .npmrc               #   -> ~/.npmrc
├── Brewfile                 # Homebrewパッケージ一覧
├── macos.sh                 # macOSシステム設定スクリプト
└── install.sh               # 統合インストールスクリプト
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

### Claude Code
- グローバル指示（CLAUDE.md）: BigQueryスケジュールドクエリ、Cloud SQLレプリカ接続
- MCPサーバー設定（Slack等）
- カスタムエージェント（レイアウトレビュー、Slack連携）
- 権限設定（settings.local.json）

### VSCode
- エディタ設定（Go、TypeScript、PHP対応）
- カスタムキーバインド（Claude Code連携、ターミナル操作、定義ジャンプ等）
- 拡張機能リスト（`code --list-extensions`でエクスポート）

### Raycast
- `.rayconfig`による完全エクスポート（ホットキー、スニペット、クイックリンク、拡張機能設定等）
- 設定を更新したら再エクスポート: Raycast > Settings > Advanced > Export で `raycast/Raycast.rayconfig` に上書き保存

### Homebrew
- `Brewfile`でbrew, cask, フォント, VSCode拡張を一括管理
- 更新: `brew bundle dump --describe --force --file=~/Workspace/dotfiles/Brewfile`

### macOS
- Dock autohide, トラックパッドのタップでクリック, ホットコーナー, ダークモード等
- `./macos.sh` で一括適用

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
