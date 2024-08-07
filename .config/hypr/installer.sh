#! /bin/bash

prep=(
	base-devel
	cliphist
	gtk3
	nwg-look
	pipewire
	pipewire-alsa
	pipewire-audio
	pipewire-pulse
	qt5-svg
	qt5-wayland
	qt5ct
	qt6-wayland
	qt6ct
	rustup
	tlp
	udiskie
	upower
	wireplumber
)

nvidia=(
	libva
	libva-nvidia-driver-git
	linux-headers
	nvidia-open
	nvidia-settings
)

packages=(
	ani-cli
	ark
	aylurs-gtk-shell
	bat
	bear
	brightnessctl
	btop
	bun-bin
	candy-icons-git
	catppuccin-cursors-mocha
	catppuccin-gtk-theme-mocha
	cbatticon
	dosfstools
	eog
	fastfetch
	firefox
	fish
	flatpak
	gamemode
	gamescope
	github-cli
	glow
	hyprpicker-git
	hyprshot
	jre-openjdk
	kcalc
	kitty
	kvantum
	kvantum-qt5
	kvantum-theme-catppuccin-git
	less
	lsd
	luarocks
	lutris
	man-db
	mangal-bin
	mangohud
	man-pages
	megacmd
	mpv
	mypy
	nautilus
	ncdu
	neovim
	nerd-fonts-inter
	networkmanager
	network-manager-applet
	networkmanager-dmenu-git
	nm-connection-editor
	noise-suppression-for-voice
	noto-fonts
	noto-fonts-cjk
	noto-fonts-emoji
	noto-fonts-extra
	npm
	obs-studio
	overskride
	partitionmanager
	pavucontrol
	playerctl
	polkit-gnome
	python-pywalfox
	pywal-git
	qbittorrent
	ranger
	rclone
	reflector
	ripgrep
	ripgrep-all
	rust-analyzer
	slimbookbattery
	starship
	steam-devices
	swaylock-effects
	swaync-git
	swayosd-git
	swww
	telegram-desktop
	thefuck
	thunderbird
	time
	tldr
	ttf-firacode-nerd
	ttf-ms-win11-auto
	unrar
	unzip
	v4l2loopback-dkms
	vesktop-bin
	wev
	whatsdesk-bin
	wofi
	xdg-desktop-portal
	xdg-desktop-portal-hyprland
	xdg-user-dirs
	xdg-utils
	ydotool
	yt-dlp
	zathura
	zathura-pdf-mupdf
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
echo "Checking for nvidia gpu..."
if [[ $(lspci | grep -i '.* vga .* nvidia .*' | count -l) = 2 ]]; then
	ISNVIDIA=true
else
	ISNVIDIA=false
fi

if [[ $ISNVIDIA = true ]]; then
	echo "Using nvidia. Installing nvidia-specific packages..."
	yay -S --needed --noconfirm --sudoloop "${nvidia[@]}"
	sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
	sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
	echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
else
	echo "Not using nvidia."
fi

yay -S --needed --noconfirm --sudoloop hyprland

# Prep
echo "Installing prep stage packages..."
yay -S --needed --noconfirm --sudoloop "${prep[@]}"

echo "Installing rust toolchains..."
rustup toolchain install stable
rustup toolchain install nightly
rustup default stable

echo "Installing hypr-workspaces..."
git clone https://github.com/adriannic/hypr-workspaces
(
	cd hypr-workspaces || exit
	makepkg -si --noconfirm --needed
)
rm -rf hypr-workspaces

echo "Enabling bluetooth..."
sudo systemctl enable --now bluetooth

echo "Enabling tlp..."
sudo systemctl enable --now tlp

# Packages
echo "Installing packages..."
yay -S --needed --noconfirm --sudoloop "${packages[@]}"

# Autologin
echo "Setting up autologin..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo "[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin adriannic %I $TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null

# Hack to be able to open term apps with wofi
echo "Creating symlink to kitty from gnome-terminal..."
sudo ln -s /usr/bin/kitty /usr/bin/gnome-terminal

# Flatpak
echo "Setting up flathub..."
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Installation complete!"
