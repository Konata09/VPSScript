#/bin/bash
cd /root
apt update && apt install -y unzip htop vim git curl wget net-tools network-manager zsh neofetch
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
mkdir -p /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJdb7V3GdgfQ6QIUTXiowt/oCgEtiLNeywDUXVHQnfx4UUItBrcnOF1VsFXuNSEJ6efifcJnT46miOHZJkWOM3PhN+WjauM6TPnAVi2fipObBmeMyTIvX5BP0MRsaq3WaUpYCLvwtwDUMsuF1pnPsuK/mUL7vptDCJPKfU7clknv8xwYdllEoSXwWgPHWJxtlw2Gbnk4+ayMGbOaR7FDkjAazByqHHg8CICTZCEd+/yd3VflX9IDHhKRFmW7/i2VdbRGYTPpOE+EdqRAiiGL1ZDNTzpSNe2YTUqEIaKk9U277As/JIqtl7+Us/ephfA3JD7jywDSjnxTLOqGnGevaqH5sCuo53j1DiluW1BCEjszPlH24YxstQN9GlVeOjZ+OhFaSDuyq048MbcYEO2lWwKmkz0cXkfzBfDWHlxe+CBur6UJkhXTHHdTFST1/hESPYfkxysYL+kOCvIAEWYnOQLKPuYYtlBlyDjf63xgHyryU+falENkdW1+IAHd7SBb8= inorilee@Inoris-MacBook-Pro.local\nssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDOAkGFOAW3zBNRwtcdZMcN2AM5xYaKWlSTmZMHizza8aES3R/XlhH+SUe6QCCSakxcvAfxs9HSRkQ5IZGQwcl7AuK+WRpxido9zAR3H+XhcW+zIW+vs9cuDPIAE6WtH2/cmPRSPuX2cu0ujc+d6F2fh81S4U9Kgvt5PJiwwjLh1EqeFP9Ler4/8qIvF4YrUYUt+D0gGbhfAxp+Ysd9Dze6cmCldHqHVt2d7dHyMO8ZfyACugZqTELqH3fJNcaM5UPKo5RCsEDasKudb81m8ul4tHwUEoGYiJfXmDz7KYBIx5w4uGeTgmrVL65W9aAwdOX76Fyxe+PCKHFyRNAhbcJq3lYXLWm2fnji7IFusjp/ofpDRWqjaoquLZVvteuMJr9p6ThEC79avfJKwRu1hkEqtsvG1t8DKUW6rgurvrG0X4CSJ9mo1vjwGanoxGCgjLJd1WZbZDIizQcJmsnHydToe9P2DxcSCnbggGa2QbFSeGwsFoqlmvoxqU9ZvXGRkbk= konata@SUZUMIYAHARUHI" >> /root/.ssh/authorized_keys
curl -fSL -O speedtest.tgz https://bintray.com/ookla/download/download_file\?file_path\=ookla-speedtest-1.0.0-x86_64-linux.tgz
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
chsh -s /bin/zsh
mkdir -p /root/speedtest && tar -xvf -C /root/speedtest speedtest.tgz
mkdir -p /root/.config/neofetch
curl -fSL https://raw.githubusercontent.com/Konata09/VPSScript/master/zsh.zshrc > /root/.zshrc
curl -fSL https://raw.githubusercontent.com/Konata09/VPSScript/master/neo.conf > /root/.config/neofetch/config.conf
wget https://cdn.ipip.net/17mon/besttrace4linux.zip
unzip -d besttrace besttrace4linux.zip
chmod +x besttrace/besttrace
