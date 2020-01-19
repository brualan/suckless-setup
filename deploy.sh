#!/bin/bash
# suckless build dependencies
sudo apt update && sudo apt install -y build-essential libx11-dev libxft-dev libxrandr-dev libxinerama-dev git curl && \

curl -O http://dl.suckless.org/st/st-0.8.2.tar.gz \
     -O http://dl.suckless.org/dwm/dwm-6.2.tar.gz \
     -O http://dl.suckless.org/tools/slock-1.4.tar.gz \
     -O http://dl.suckless.org/tools/dmenu-4.9.tar.gz && \

for f in *.tar.gz; do tar -xzf "$f"; done

# st
cp -t st-0.8.2 st-config/* && \
cd st-0.8.2 && \
sudo make install && \
cd .. && \

# dwm
cp -t dwm-6.2 dwm-config/* && \
cd dwm-6.2 && \
patch -p1 < dwm-autostart-20161205-bb3bd6f.diff && \
sudo make install && \
cd .. && \
sudo cp -v dwm.desktop /usr/share/xsessions
mkdir -p ~/.dwm && \
cp autostart.sh ~/.dwm/autostart.sh && \
chmod +x ~/.dwm/autostart.sh

# slock
cp -t slock-1.4 slock-config/* && \
cd slock-1.4 && \
patch -p1 < slock-dpms-20170923-fa11589.diff
sudo make install && \
cd .. && \

# dmenu
cd dmenu-4.9 && \
sudo make install && \
cd .. && \

# cleanup
rm -rf st-0.8.2 \
       dmenu-4.9 \
       slock-1.4 \
       dwm-6.2 \
       *tar.gz

