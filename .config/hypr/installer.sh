#! /bin/bash

export MAKEFLAGS="-j $(nproc)"

prep=(
	archlinux-xdg-menu
	base
	base-devel
	btrfs-progs
	cmake
	cups
	cups-pk-helper
	docker
	docker-compose
	firewall-applet
	git
	hyprqt6engine
	lib32-vulkan-radeon
	linux
	linux-firmware
	nwg-look
	phonon-qt6-mpv
	pipewire
	rocm-hip-sdk
	rocm-opencl-sdk
	rsync
	rustup
	sddm-git
	socat
	udiskie
	vulkan-radeon
	zram-generator
)

optdeps=(
	dosfstools
	exfat-utils
	ffmpegthumbs
	ghostscript
	gst-libav
	gst-plugin-pipewire
	gst-plugins-ugly
	npm
	openbsd-netcat
	pipewire-alsa
	pipewire-audio
	pipewire-jack
	pipewire-pulse
	unixodbc
	unrar
	unzip
	v4l2loopback-dkms
	wine
	wireplumber
	zathura-pdf-mupdf
)

nvidia=(
	libva
	libva-nvidia-driver
	linux-headers
	nvidia
	nvidia-settings
)

packages=(
	amd-container-toolkit
	anydesk-bin
	ark
	awww
	bat
	bear
	blueberry
	brave-origin-bin
	brightnessctl
	btop
	candy-icons-git
	cbatticon
	cliphist
	darkly-bin
	dialog
	discord
	dolphin
	fastfetch
	fish
	flatpak
	fzf
	gamemode
	gamescope
	gdu
	git-delta
	github-cli
	glow
	hypridle
	hyprland
	hyprland-preview-share-picker-git
	hyprlock
	hyprpicker
	hyprshot
	jre-openjdk
	kitty
	lib32-gamemode
	libvirt
	loupe
	lsd
	luarocks
	lutris
	man-db
	man-pages
	mangal-bin
	mangohud
	megacmd-bin
	mpv
	mpvpaper
	mypy
	neovim
	nerd-fonts-inter
	network-manager-applet
	networkmanager
	networkmanager-dmenu-git
	nm-connection-editor
	noise-suppression-for-voice
	noto-fonts
	noto-fonts-cjk
	noto-fonts-emoji
	noto-fonts-extra
	obs-studio
	pacman-contrib
	partitionmanager
	pavucontrol
	pear-desktop
	playerctl
	polkit-gnome
	prismlauncher
	protonplus
	protontricks
	pywal-git
	qbittorrent
	qemu-full
	quickshell
	rclone
	reflector
	ripgrep-all
	rustdesk-bin
	sddm-minesddm-theme
	starship
	steam
	sunshine-bin
	swayosd-git
	syncplay
	system-config-printer
	tectonic
	telegram-desktop
	thunderbird
	time
	tldr
	tree-sitter-cli
	ttf-dejavu
	ttf-firacode-nerd
	ttf-liberation
	vm-curator-bin
	walogram-git
	waypipe
	whatsdesk-bin
	winboat-bin
	wl-clip-persist
	wofi
	xdg-desktop-portal-hyprland
	xdg-user-dirs
	yarn
	ydotool
	yt-dlp
	zathura
	zip
	zoxide
)

sudo pacman -S --needed --noconfirm base-devel git

# Configs
echo "Cloning dotfiles..."
git clone --bare https://github.com/adriannic/dotfiles "$HOME"/.dotfiles
git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" checkout -f
git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" submodule update --init --recursive
git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" submodule foreach git checkout main

# Clone nvim
git clone https://github.com/adriannic/nvim-config "$HOME"/.config/nvim

# Clone quickshell
git clone https://github.com/adriannic/quickshell-dotfiles "$HOME"/.config/quickshell

# Installing yay
echo "Checking if yay is installed..."
[[ ! $(yay -V) ]] && (
	echo "Installing yay..."
	git clone https://aur.archlinux.org/yay.git
	(
		cd yay || return
		makepkg -si --noconfirm --needed
	)
	rm -rf yay
)

# Updating system packages
yay --noconfirm

# Check for nvidia
if lspci -k -d ::03xx | grep NV >/dev/null 2>&1; then
	echo "Using nvidia. Installing nvidia-specific packages..."
	yay -S --needed --noconfirm --sudoloop "${nvidia[@]}"
	sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
	sudo mkinitcpio -P
	echo -e "options nvidia-drm modeset=1 fbdev=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
else
	echo "Not using nvidia."
fi

# Prep
echo "Installing prep stage packages..."
yay -S --needed --noconfirm --sudoloop "${prep[@]}"

echo "Installing optional dependencies..."
yay -S --needed --noconfirm --sudoloop "${optdeps[@]}"

echo "Installing rust toolchains..."
rustup toolchain install stable
rustup toolchain install nightly
rustup default stable
rustup component add rust-analyzer

echo "Enabling bluetooth..."
sudo systemctl enable --now bluetooth

echo "Enabling firewalld..."
sudo systemctl enable --now firewalld

echo "Enabling docker..."
sudo systemctl enable --now docker

echo "Setting up archlinux-xdg-menu..."
XDG_MENU_PREFIX=arch- kbuildsycoca6

# Packages
echo "Installing packages..."
yay -S --needed --noconfirm --sudoloop "${packages[@]}"

# Remove phonon-qt6-vlc
yay -Rns --noconfirm --sudoloop phonon-qt6-vlc

# Install sddm-hyprland (aur package is broken)
git clone https://aur.archlinux.org/sddm-hyprland.git
(
	cd sddm-hyprland || return
	sed PKGBUILD --in-place -e 's/\/hyprland.conf/\/hyprland.lua/g' -e 's/\/hyprprefs.conf/\/hyprprefs.lua/g'
	makepkg -si --noconfirm --needed
)
rm -rf sddm-hyprland

# yay cleanup
yay -Yc
yay -Sc
sudo rm -rf /var/lib/pacman/pkg/*

echo "Configuring user groups..."
sudo usermod -aG docker,render,video "$(id -un)"

# Hyprland plugins
# hyprpm update
# hyprpm add https://github.com/alexhulbert/Hyprchroma
# hyprpm enable hyprchroma

# Autologin
echo "Setting up autologin..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo "[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin adriannic %I $TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null

# Setup SDDM
echo "Setting up SDDM..."
echo "[Theme]
Current=minesddm" | sudo tee /etc/sddm.conf >/dev/null
sudo systemctl enable sddm

# Hack to be able to open term apps with wofi
echo "Creating symlink to kitty from gnome-terminal..."
sudo ln -s /usr/bin/kitty /usr/bin/gnome-terminal

echo "Installation complete!"
