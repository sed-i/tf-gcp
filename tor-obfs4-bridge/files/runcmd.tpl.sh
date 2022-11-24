set -eux

DEBIAN_FRONTEND=noninteractive apt -y upgrade


# disable swap
sysctl -w vm.swappiness=0
echo "vm.swappiness = 0" | tee -a /etc/sysctl.conf
swapoff -a


# disable unnecessary services
systemctl disable apport.service apport-autoreport.service --now
# systemctl disable apt-daily.service apt-daily.timer --now
# systemctl disable apt-daily-upgrade.service apt-daily-upgrade.timer --now
# systemctl disable unattended-upgrades.service --now
systemctl disable motd-news.service motd-news.timer --now
systemctl disable bluetooth.target --now
systemctl disable ua-timer.timer ua-timer.service ubuntu-advantage.service --now
systemctl disable systemd-tmpfiles-clean.timer --now


# start services
# systemctl daemon-reload
# systemctl start node-exporter.service


# apt cleanup
apt remove -y landscape-client landscape-common
apt-get autoremove -y


# oh-my-zsh
sudo -u ubuntu sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo -u ubuntu git clone https://github.com/zsh-users/zsh-autosuggestions.git ~ubuntu/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sudo -u ubuntu git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~ubuntu/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
sudo -u ubuntu sed -i 's/plugins=(git)/plugins=(fzf git zsh-autosuggestions zsh-syntax-highlighting virtualenv colored-man-pages colorize)/g' ~ubuntu/.zshrc
sudo -u ubuntu sed -i 's/^ZSH_THEME=.*/ZSH_THEME=bureau/g' ~ubuntu/.zshrc

# start docker-compose
# TODO check if persists VM restart
docker-compose -f /tor-obfs4-bridge/docker-compose.yml up -d obfs4-bridge
