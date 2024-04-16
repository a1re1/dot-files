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

# set up aliases
if ! grep "alias reload=" ~/.bashrc &>/dev/null; then
	echo "alias reload='source ~/.bashrc'" >>~/.bashrc
fi
if ! grep "alias vim=" ~/.bashrc &>/dev/null; then
	echo "alias vim='nvim'" >>~/.bashrc
fi

echo "✅ Done! Please open a new terminal to finish setup."
