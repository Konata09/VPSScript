#!/bin/bash

apt update && apt install -y unzip htop vim git curl wget net-tools ca-certificates openssl zsh libncursesw5-dev autotools-dev autoconf build-essential iperf3 fastfetch grc gnupg2 lsb-release debian-archive-keyring socat

# add ssh keys
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
curl -fSL https://raw.githubusercontent.com/Konata09/VPSScript/master/ssh_public_keys >> ~/.ssh/authorized_keys

# install oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# install zsh plugins and configuration
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
curl -fSL https://raw.githubusercontent.com/Konata09/VPSScript/master/zsh.zshrc > /root/.zshrc
chsh -s /bin/zsh

# install speedtest
mkdir -p /opt/speedtest && cd /opt/speedtest
wget https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-x86_64-linux.tgz
tar -xvf ookla-speedtest-1.0.0-x86_64-linux.tgz
rm ookla-speedtest-1.0.0-x86_64-linux.tgz

# copy fastfetch configuration
mkdir -p /root/.config/fastfetch
curl -fSL https://raw.githubusercontent.com/Konata09/VPSScript/master/fastfetch.jsonc > /root/.config/fastfetch/config.jsonc

# copy neofetch configuration
# mkdir -p /root/.config/neofetch
# curl -fSL https://raw.githubusercontent.com/Konata09/VPSScript/master/neo.conf > /root/.config/neofetch/config.conf

# install xanmod kernel
wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -vo /etc/apt/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list
apt update && apt install linux-xanmod-x64v3
update-grub

# install nginx
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx
apt update
apt install nginx

# install zabbix agent
cd ~
wget https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_7.0-1+debian12_all.deb
dpkg -i zabbix-release_7.0-1+debian12_all.deb
apt update
apt install zabbix-agent2
rm zabbix-release_7.0-1+debian12_all.deb

# install acme.sh
curl https://get.acme.sh | sh -s email=abuse@bronya.moe

# install golang
wget https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> /root/.zshrc
rm go1.16.3.linux-amd64.tar.gz

# install speedtest-go
cd /opt && git clone https://github.com/librespeed/speedtest-go.git
cd speedtest-go
go build -ldflags "-w -s" -trimpath -o speedtest main.go

# install besttrace
cd /opt && wget https://cdn.ipip.net/17mon/besttrace4linux.zip
unzip -d besttrace besttrace4linux.zip
chmod +x besttrace/besttrace
rm besttrace4linux.zip
