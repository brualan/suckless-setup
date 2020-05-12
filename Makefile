USER_HOME := $(shell echo ~$(SUDO_USER))
SRC_TEMP := $(shell mktemp -d)

software:
	apt update
	apt install -y sxiv htop tmux sysstat nload pass curl git mpv ffmpeg restic rsync imagemagick webp jq jdupes zathura zathura-djvu zathura-pdf-poppler zathura-ps entr deborphan
	mkdir -p $(USER_HOME)/.config/zathura
	cp dotfiles/zathurarc $(USER_HOME)/.config/zathura/zathurarc
build-dependencies:
	apt update
	apt install -y build-essential libx11-dev libxft-dev libxrandr-dev libxinerama-dev git curl

st-0.8.3.tar.gz:
	curl --silent -O http://dl.suckless.org/st/st-0.8.3.tar.gz
dwm-6.2.tar.gz:
	curl --silent -O http://dl.suckless.org/dwm/dwm-6.2.tar.gz
slock-1.4.tar.gz:
	curl --silent -O http://dl.suckless.org/tools/slock-1.4.tar.gz
dmenu-4.9.tar.gz:
	curl --silent -O http://dl.suckless.org/tools/dmenu-4.9.tar.gz

st-0.8.3: st-0.8.3.tar.gz
	tar -xzf st-0.8.3.tar.gz -C $(SRC_TEMP)
dwm-6.2: dwm-6.2.tar.gz
	tar -xzf dwm-6.2.tar.gz -C $(SRC_TEMP)
slock-1.4: slock-1.4.tar.gz
	tar -xzf slock-1.4.tar.gz -C $(SRC_TEMP)
dmenu-4.9: dmenu-4.9.tar.gz
	tar -xzf dmenu-4.9.tar.gz -C $(SRC_TEMP)

install-st: st-0.8.3
	cp -t $(SRC_TEMP)/st-0.8.3 st-config/config.h
	make -C $(SRC_TEMP)/st-0.8.3 install
install-dwm: dwm-6.2
	cp -t $(SRC_TEMP)/dwm-6.2 dwm-config/config.h
	patch -d $(SRC_TEMP)/dwm-6.2 -p1 < dwm-config/dwm-autostart-20161205-bb3bd6f.diff
	make -C $(SRC_TEMP)/dwm-6.2 install
	cp -v dwm-config/dwm.desktop /usr/share/xsessions
	mkdir -p $(USER_HOME)/.dwm
	cp dwm-config/autostart.sh $(USER_HOME)/.dwm/autostart.sh
	chmod +x $(USER_HOME)/.dwm/autostart.sh
	cp dwm-config/brightness.service /etc/systemd/system/
	systemctl daemon-reload
	systemctl enable brightness.service
install-slock: slock-1.4
	cp -t $(SRC_TEMP)/slock-1.4 slock-config/config.h
	patch -d $(SRC_TEMP)/slock-1.4 -p1 < slock-config/slock-dpms-20170923-fa11589.diff
	make -C $(SRC_TEMP)/slock-1.4 install
install-dmenu: dmenu-4.9
	make -C $(SRC_TEMP)/dmenu-4.9 install


install-all: software build-dependencies install-st install-dwm install-slock install-dmenu font nvim terminal fzf utils golang telegram


font:
	$(eval TMP_FILE := $(shell mktemp))
	curl -o $(TMP_FILE) -L --silent `curl --silent "https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/'`
	unzip $(TMP_FILE) -d $(USER_HOME)/.local/share/fonts/
	fc-cache -f -v
nvim:
	$(eval TMP_DIR := $(shell mktemp -d))
	apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
	git clone https://github.com/neovim/neovim.git $(TMP_DIR)/neovim --branch stable --single-branch
	make CMAKE_BUILD_TYPE=Release -C $(TMP_DIR)/neovim
	make install -C $(TMP_DIR)/neovim
	cp neovim/init.vim $(USER_HOME)/.config/nvim/init.vim
terminal:
	rm -f $(USER_HOME)/.bashrc $(USER_HOME)/.profile $(USER_HOME)/.tmux.conf $(USER_HOME)/.config/user-dirs.dirs
	cp -r dotfiles $(USER_HOME)/.config/
	ln -s $(USER_HOME)/.config/dotfiles/bashrc $(USER_HOME)/.bashrc
	ln -s $(USER_HOME)/.config/dotfiles/profile $(USER_HOME)/.profile
	ln -s $(USER_HOME)/.config/dotfiles/user-dirs.dirs $(USER_HOME)/.config/user-dirs.dirs
	ln -s $(USER_HOME)/.config/dotfiles/tmux.conf $(USER_HOME)/.tmux.conf
fzf:
	git clone --depth 1 https://github.com/junegunn/fzf.git $(USER_HOME)/.fzf
	$(USER_HOME)/.fzf/install --key-bindings --completion --update-rc --no-zsh --no-fish
utils: fzf
	git clone https://github.com/brualan/utils.git $(USER_HOME)/utils
golang:
	$(eval TMP_FILE := $(shell mktemp))
	curl -o $(TMP_FILE) -L `curl --silent https://golang.org/dl/ | grep -oP 'https:\/\/dl\.google\.com\/go\/go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1`
	tar -C /usr/local -xzf $(TMP_FILE)
	grep 'export PATH=$(PATH):/usr/local/go/bin' $(USER_HOME)/.profile || echo 'export PATH=$(PATH):/usr/local/go/bin' >> $(USER_HOME)/.profile
telegram:
	$(eval TMP_FILE := $(shell mktemp))
	curl -o $(TMP_FILE) -L `curl --silent "https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/' | grep 'tsetup\..*.tar.xz'`
	tar xf $(TMP_FILE) -C /tmp --no-anchored Telegram/Telegram --strip-components=1
	mv /tmp/Telegram /usr/local/bin/telegram
