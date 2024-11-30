#!/bin/bash

yum update && yum -y install dnf dnf-plugins-core
dnf -y update
dnf -y install unzip vim git curl wget net-tools zsh ncurses-devel automake autoconf make gcc iperf3 grc

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

# install fastfetch
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.30.1/fastfetch-linux-amd64.rpm
rpm -i fastfetch-linux-amd64.rpm
rm fastfetch-linux-amd64.rpm

# install speedtest
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash
yum install speedtest-cli

# install golang
wget https://golang.org/dl/go1.17.3.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.3.linux-amd64.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" >> /root/.zshrc
rm go1.17.3.linux-amd64.tar.gz

# install speedtest-go
cd /opt && git clone https://github.com/librespeed/speedtest-go.git
cd speedtest-go
go build -ldflags "-w -s" -trimpath -o speedtest main.go

# install besttrace
cd /opt && wget https://cdn.ipip.net/17mon/besttrace4linux.zip
unzip -d besttrace besttrace4linux.zip
chmod +x besttrace/besttrace
rm esttrace4linux.zip
