#!/bin/bash

# if oh-my-bash
if [ ! -d "~/.oh-my-bash" ]; then
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
fi

# set up powerline theme
sed -i "/OSH_THEME=/c\OSH_THEME=\"powerline\"" ~/.bashrc

# if nvim isnt installed yet install it
if ! command -v nvim &>/dev/null; then
	echo "nvim could not be found, installing..."
	mkdir -p ~/downloads
	cd ~/downloads
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x nvim.appimage
	./nvim.appimage --appimage-extract
	./squashfs-root/AppRun --version
	sudo mv squashfs-root /
	sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
fi

# setup nvim config
if [ ! -d "~/.config/nvim" ]; then
	git clone https://github.com/a1re1/vim-dotfiles.git ~/.config/nvim
fi

if [ ! -d "~/blossom" ]; then
	git clone https://github.com/a1re1/blossom.git ~/blossom
	chmod +x ~/blossom/main
fi

# set up aliases
if ! grep "alias reload=" ~/.bashrc &>/dev/null; then
	echo "alias reload='source ~/.bashrc'" >>~/.bashrc
fi
if ! grep "alias vim=" ~/.bashrc &>/dev/null; then
	echo "alias vim='nvim'" >>~/.bashrc
fi
if !grep "alias blossom=" ~/.bashrc &>/dev/null; then
	echo "alias blossom='~/blossom/main'" >>~/.bashrc
fi

sudo apt update && sudo apt upgrade -y
sudo apt install openjdk-21-jdk -y
export PATH=/usr/lib/jvm/java-21-openjdk-amd64/bin:$PATH
echo "export PATH=/usr/lib/jvm/java-21-openjdk-amd64/bin:\$PATH" >>~/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
echo "export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64/bin" >>~/.bashrc

echo "✅ Done! Please open a new terminal to finish setup."
