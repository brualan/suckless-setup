USER_HOME := $(shell echo ~$(SUDO_USER))
SRC_TEMP := $(shell mktemp -d)

software:
	pacman -Sy --needed --noconfirm go sxiv htop tmux sysstat nload pass curl git mpv ffmpeg restic rsync imagemagick jq zathura zathura-djvu zathura-pdf-poppler zathura-ps entr unzip base-devel libx11 libxft libxrandr libxinerama git curl firefox bash-completion
	mkdir -p $(USER_HOME)/.config/zathura
	cp dotfiles/zathurarc $(USER_HOME)/.config/zathura/zathurarc

nvim-config:
	sudo pacman -Sy --needed --noconfirm neovim git go # check that we have needed deps
	rm -rf $(USER_HOME)/.config/nvim # cleanup any previous configs
	mkdir -p $(USER_HOME)/.config/nvim
	cp neovim/init.vim $(USER_HOME)/.config/nvim/init.vim
	git clone https://github.com/VundleVim/Vundle.vim.git $(USER_HOME)/.config/nvim/bundle/Vundle.vim
	nvim +'PluginInstall' +'GoInstallBinaries'  +qa
	@echo -------------
	@echo
	@echo Don\'t forget to manualy run \':COQdeps\' and \':COQnow\' in NeoVim
	@echo
	@echo -------------

st-0.8.5.tar.gz:
	curl --silent -O http://dl.suckless.org/st/st-0.8.5.tar.gz
dwm-6.3.tar.gz:
	curl --silent -O http://dl.suckless.org/dwm/dwm-6.3.tar.gz
slock-1.4.tar.gz:
	curl --silent -O http://dl.suckless.org/tools/slock-1.4.tar.gz
dmenu-4.9.tar.gz:
	#curl --silent -O http://dl.suckless.org/tools/dmenu-4.9.tar.gz

st-0.8.5: st-0.8.5.tar.gz
	tar -xzf st-0.8.5.tar.gz -C $(SRC_TEMP)
dwm-6.3: dwm-6.3.tar.gz
	tar -xzf dwm-6.3.tar.gz -C $(SRC_TEMP)
slock-1.4: slock-1.4.tar.gz
	tar -xzf slock-1.4.tar.gz -C $(SRC_TEMP)
dmenu-4.9: # dmenu-4.9.tar.gz
	git clone git://git.suckless.org/dmenu "$(SRC_TEMP)/dmenu-4.9"
	#tar -xzf dmenu-4.9.tar.gz -C $(SRC_TEMP)

install-st: st-0.8.5
	cp -t $(SRC_TEMP)/st-0.8.5 st-config/config.h
	sudo make -C $(SRC_TEMP)/st-0.8.5 install
install-dwm: dwm-6.3
	cp -t $(SRC_TEMP)/dwm-6.3 dwm-config/config.h
	patch -d $(SRC_TEMP)/dwm-6.3 -p1 < dwm-config/dwm-autostart-20161205-bb3bd6f.diff
	sudo make -C $(SRC_TEMP)/dwm-6.3 install
	sudo cp -v dwm-config/dwm.desktop /usr/share/xsessions
	mkdir -p $(USER_HOME)/.config/dwm
	cp dwm-config/autostart.sh $(USER_HOME)/.config/dwm/autostart.sh
	chmod +x $(USER_HOME)/.config/dwm/autostart.sh
	sudo cp dwm-config/brightness.service /etc/systemd/system/
	sudo systemctl daemon-reload
	sudo systemctl enable brightness.service
install-slock: slock-1.4
	cp -t $(SRC_TEMP)/slock-1.4 slock-config/config.h
	patch -d $(SRC_TEMP)/slock-1.4 -p1 < slock-config/slock-dpms-20170923-fa11589.diff
	make -C $(SRC_TEMP)/slock-1.4 install
install-dmenu: dmenu-4.9
	make -C $(SRC_TEMP)/dmenu-4.9 install

install-keyboad-conf:
	sudo cp xorg/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf


install-all: software install-st install-dwm install-slock install-dmenu font terminal utils


font:
	$(eval TMP_FILE := $(shell mktemp))
	curl -o $(TMP_FILE) -L --silent `curl --silent "https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/'`
	unzip $(TMP_FILE) -d $(USER_HOME)/.local/share/fonts/
	fc-cache -f -v
terminal:
	rm -f $(USER_HOME)/.bashrc $(USER_HOME)/.profile $(USER_HOME)/.tmux.conf $(USER_HOME)/.config/user-dirs.dirs
	cp -r dotfiles $(USER_HOME)/.config/
	ln -s $(USER_HOME)/.config/dotfiles/bashrc $(USER_HOME)/.bashrc
	ln -s $(USER_HOME)/.config/dotfiles/profile $(USER_HOME)/.profile
	ln -s $(USER_HOME)/.config/dotfiles/user-dirs.dirs $(USER_HOME)/.config/user-dirs.dirs
	ln -s $(USER_HOME)/.config/dotfiles/tmux.conf $(USER_HOME)/.tmux.conf
utils:
	rm -rf $(USER_HOME)/utils
	git clone https://github.com/brualan/utils.git $(USER_HOME)/utils
