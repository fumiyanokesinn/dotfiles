# =====================================
# Interactive shell
# =====================================
if status is-interactive
    # fzf history search (Ctrl+R)
    bind \cr 'history | fzf --height 40% --reverse | read -l cmd; and commandline $cmd'

    # Auto ls on directory change
    function ls_on_cd --on-variable PWD
        ls
    end
end

# =====================================
# Homebrew (Apple Silicon)
# =====================================
eval (/opt/homebrew/bin/brew shellenv)

# =====================================
# Starship prompt
# =====================================
starship init fish | source

# =====================================
# goenv
# =====================================
if type -q goenv
    set -gx GOENV_ROOT "$HOME/.goenv"
    set -gx PATH "$GOENV_ROOT/shims" $PATH
    goenv init - | source
    fish_add_path $GOPATH/bin
end

# =====================================
# direnv
# =====================================
if type -q direnv
    direnv hook fish | source
end

# =====================================
# zoxide (smart cd)
# =====================================
if type -q zoxide
    zoxide init fish | source
end
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.vite-plus/bin
fish_add_path $HOME/.volta/bin
fish_add_path $HOME/.npm-global/bin

# =====================================
# Python package registry (Flatt Security proxy)
# =====================================
# pip の取得先を Takumi Guard 経由にし、悪性パッケージをブロックする。
# uv は PIP_INDEX_URL を見ないため uv.toml 側で別途設定する。
set -gx PIP_INDEX_URL https://pypi.flatt.tech/simple/
set -gx HOMEBREW_GITHUB_API_TOKEN (gh auth token)
