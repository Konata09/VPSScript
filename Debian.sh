#!/bin/bash

apt update && apt install -y unzip htop vim git curl wget net-tools ca-certificates openssl zsh libncursesw5-dev autotools-dev autoconf build-essential iperf3 neofetch grc

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

# copy neofetch configuration
mkdir -p /root/.config/neofetch
curl -fSL https://raw.githubusercontent.com/Konata09/VPSScript/master/neo.conf > /root/.config/neofetch/config.conf

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
