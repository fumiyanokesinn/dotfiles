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
- **bin**: `~/.local/bin` 用汎用スクリプト（Keychain管理・移行ツール）
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
rm ~/.claude/CLAUDE.md ~/.claude/settings.json ~/.claude/.mcp.json ~/.claude/.claude/settings.local.json
rm ~/.claude/agents/basemachina-operator.md ~/.claude/agents/review-layout.md ~/.claude/agents/slack-communicator.md
rm -rf ~/.claude/skills/basemachina-skill
rm ~/.claude/gcp-prod-guard/allowed-commands.txt
rm ~/.claude/hooks/cmux-notify.sh
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
│   ├── settings.json        #   -> ~/.claude/settings.json（permissions, hooks, enabledPlugins等）
│   ├── .mcp.json            #   -> ~/.claude/.mcp.json
│   ├── agents/              #   -> ~/.claude/agents/*.md
│   │   ├── basemachina-operator.md
│   │   ├── review-layout.md
│   │   └── slack-communicator.md
│   ├── skills/              #   -> ~/.claude/skills/<skill>/<files>
│   │   └── basemachina-skill/
│   │       └── SKILL.md
│   ├── gcp-prod-guard/      #   -> ~/.claude/gcp-prod-guard/*
│   │   └── allowed-commands.txt
│   ├── hooks/               #   -> ~/.claude/hooks/*.sh
│   │   └── cmux-notify.sh
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
- ユーザー設定（settings.json）: permissions allow, hooks, statusLine, **enabledPlugins**, extraKnownMarketplaces, env
- MCPサーバー設定（.mcp.json）: Slack等。OAuth は新PCで再認証
- カスタムエージェント（agents/）: basemachina-operator, review-layout, slack-communicator
- カスタムスキル（skills/）: basemachina-skill
- gcp-prod-guard 許可コマンド（gcp-prod-guard/allowed-commands.txt）
- フック（hooks/cmux-notify.sh）: cmux サイドバー連携
- ローカル権限（.claude/settings.local.json）

> **注**: settings.json はリンク経由でdotfiles実体に書き込まれるため、 `/plugin install` 等の操作で自動的に git diff が発生する。プラグイン構成も dotfiles で追跡される。

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

## 新PCへの移行

### Keychain 認証情報の移行（user-creds/*）

`setup-keychain` で登録した認証情報は macOS Keychain に保存されるため、dotfiles（git）には含まれない。別PCへ移す場合は `age` で暗号化エクスポート→復号インポート。

**旧PC（エクスポート）:**

```bash
# age 未導入なら
brew install age

# user-creds/* 全件を暗号化エクスポート
export-keychain
# → ~/keychain-backup-YYYYMMDD.age が出力される
#    age パスフレーズを設定（復号時に必要）
```

**新PC（インポート）:**

```bash
# dotfiles セットアップ後（age は Brewfile に含まれる）
./install.sh

# バックアップを安全に転送（暗号化USB, AirDrop等）
# dry-run で中身確認
import-keychain ~/keychain-backup-YYYYMMDD.age --dry-run

# 実登録
import-keychain ~/keychain-backup-YYYYMMDD.age
```

**注意:**

- `.age` ファイルは git 管理外。暗号化済だが扱いは秘密情報として
- Claude Code 認証は Keychain の `Claude Code-credentials` に入るが移行対象外。新PCで `claude login` 再実行
- パスフレーズは 1Password 等で別途管理

## ライセンス

MIT
