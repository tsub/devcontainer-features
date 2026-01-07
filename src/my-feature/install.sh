#!/bin/sh -e

sudo apt update -y # for dotfiles
sudo apt install -y file libmagic1 libmagic-mgc # for fish
# echo 'legacy_version_file = yes' > ~/.asdfrc
go install github.com/Ladicle/git-prompt@latest # for fish theme
go install github.com/k1LoW/git-wt@latest
npm i -g yaml-language-server # for neovim
npm i -g @aku11i/phantom
npm i -g ccmanager
npm i -g ccusage
npm i -g difit

# See: https://zenn.dev/st_little/articles/permission-denied-on-sed-command
wget -P /tmp https://ftp.gnu.org/gnu/sed/sed-4.8.tar.xz \
    && tar -Jxvf /tmp/sed-4.8.tar.xz -C /tmp \
    && cd /tmp/sed-4.8 \
    && ./configure \
    && make \
    && make install

# ホストからマウントするためにコンテナ内に予め必要なディレクトリを作成する
su "${_REMOTE_USER}" -c 'mkdir -p ~/.ssh'
su "${_REMOTE_USER}" -c 'mkdir -p ~/.config/gh'
su "${_REMOTE_USER}" -c 'mkdir -p ~/.config/git'
su "${_REMOTE_USER}" -c 'mkdir -p ~/.config/fish'
su "${_REMOTE_USER}" -c 'mkdir -p ~/.claude'
su "${_REMOTE_USER}" -c 'touch ~/.config/fish/config.fish'

# fish の補完を設定
echo 'phantom completion fish | source' >> "${_REMOTE_USER_HOME}/.config/fish/config.fish"

# dotfiles のインストール
# devcontainer/cli の --dotfiles-repository オプションよりも feature のレイヤーキャッシュが効いた方がビルドが速そうなため
su "${_REMOTE_USER}" -c 'git clone https://github.com/tsub/dotfiles.git ~/dotfiles'
su "${_REMOTE_USER}" -c '~/dotfiles/install.sh'
