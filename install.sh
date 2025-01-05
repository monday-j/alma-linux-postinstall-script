#!/bin/bash
echo "Running the monday_j alma linux kitten post-install script..."

# update packages
echo "Updating packages. Please input the sudo password when prompted."
sudo dnf update --refresh -y

# set up software repositories
echo "Setting up software repositories now..."

# install epel 10 https://docs.fedoraproject.org/en-US/epel/getting-started/#_centos_stream_10
echo "Setting up Extra Packages for Enterprise Linux... "
sudo config-manager --set-enabled crb
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm -y
sudo crb enable

# # install RPM Fusion
# echo "Setting up RPM Fusion..."
# sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y
# echo "Updating RPM Fusion packages in GNOME Software and KDE Discover"
# sudo dnf update @core

# install basic packages via dnf
echo "Installing basic packages via DNF..."
sudo dnf install zsh stow neofetch curl python3-pip python3-wheel make gcc gcc-c++

# install Micro and zip it to /usr/bin/micro
echo "Installing Micro..."
curl https://getmic.ro | bash
sudo mv micro /usr/bin

# set up docker
echo "Installing Docker..."
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install github CLI 
echo "Installing Github CLI..."
sudo dnf install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh --repo gh-cli -y

# log into github
gh auth login

# clone .dotfiles, then stow and adopt them into home directory - https://github.com/monday-j/.dotfiles
echo "Cloning .dotfiles..."
cd ~
git clone https://github.com/monday-j/.dotfiles
cd .dotfiles
stow . --adopt
git restore .
cd ~

# change shell to zsh
echo "Changing shell to ZSH..."
sudo chsh -s $(which zsh) joshua

# place in new .zsh environment
echo "All done - placing in new terminal environment!"
exec zsh

# finishing touches
echo "Cool. You should probably reboot now."
