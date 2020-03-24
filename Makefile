dependencies:
	apt update
	apt install -y build-essential libx11-dev libxft-dev libxrandr-dev libxinerama-dev git curl
st-0.8.2.tar.gz:
	curl -O http://dl.suckless.org/st/st-0.8.2.tar.gz
dwm-6.2.tar.gz:
	curl -O http://dl.suckless.org/dwm/dwm-6.2.tar.gz
slock-1.4.tar.gz:
	curl -O http://dl.suckless.org/tools/slock-1.4.tar.gz
dmenu-4.9.tar.gz:
	curl -O http://dl.suckless.org/tools/dmenu-4.9.tar.gz

st-0.8.2: st-0.8.2.tar.gz
	tar -xzf st-0.8.2.tar.gz
dwm-6.2: dwm-6.2.tar.gz
	tar -xzf dwm-6.2.tar.gz
slock-1.4: slock-1.4.tar.gz
	tar -xzf slock-1.4.tar.gz
dmenu-4.9: dmenu-4.9.tar.gz
	tar -xzf dmenu-4.9.tar.gz

install-st: st-0.8.2
	cp -t st-0.8.2 st-config/config.h
	make -C st-0.8.2 install
install-dwm: dwm-6.2
	cp -t dwm-6.2 dwm-config/config.h
	patch -d dwm-6.2 -p1 < dwm-config/dwm-autostart-20161205-bb3bd6f.diff
	make -C dwm-6.2 install
	sudo cp -v dwm-config/dwm.desktop /usr/share/xsessions
	mkdir -p ~/.dwm
	cp dwm-config/autostart.sh ~/.dwm/autostart.sh
	chmod +x ~/.dwm/autostart.sh
	cp dwm-config/brightness.service /etc/systemd/system/
	systemctl daemon-reload
	systemctl enable brightness.service
install-slock: slock-1.4
	cp -t slock-1.4 slock-config/config.h
	patch -d slock-1.4 -p1 < slock-config/slock-dpms-20170923-fa11589.diff
	make -C slock-1.4 install
install-dmenu: dmenu-4.9
	make -C dmenu-4.9 install

install-all: dependencies install-st install-dwm install-slock install-dmenu

clean:
	rm -rf st-0.8.2 dmenu-4.9 slock-1.4 dwm-6.2 *tar.gz

