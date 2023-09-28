#! /bin/bash

prep=(
	base-devel
	bluez
	bluez-utils
	cliphist
	gtk3
	jq
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
	wireplumber
	wl-clip-persist-git
	wl-clipboard
)

nvidia=(
	libva
	libva-nvidia-driver-git
	linux-headers
	nvidia
	nvidia-settings
)

packages=(
	ani-cli
	ark
	blueberry
	bottom
	brightnessctl
	cli-visualizer
	discord
	dolphin
	dolphin-plugins
	eww-wayland
	firefox
	fish
	flatpak
	gamemode
	gamescope
	github-cli
	hyprpicker-git
	hyprshot
	jre-openjdk
	kcalc
	kitty
	less
	lsd
	luarocks
	lutris
	man-db
	man-pages
	mangal-bin
	mangohud
	megasync-bin
	mpv
	ncdu
	neofetch
	neovim
	nerd-fonts-inter
	networkmanager
	networkmanager-dmenu-git
	nm-connection-editor
	npm
	obs-studio
	partitionmanager
	pavucontrol
	playerctl
	polkit-kde-agent
	pulsemixer
	python-pywalfox
	pywal-git
	qbittorrent
	ranger
	rclone
	reflector
	ripgrep
	ripgrep-all
	rsync
	spotify-adblock
	stacer
	starship
	steam-devices
	swappy
	swaylock-effects
	swaync-git
	swayosd-git
	sweet-folders-icons-git
	sweet-theme-full-git
	swww
	telegram-desktop
	time
	tldr
	ttf-firacode-nerd
	unrar
	unzip
	v4l2loopback-dkms
	wev
	whatsdesk-bin
	wlrobs-hg
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

# Check for nvidia
echo "Checking for nvidia gpu..."
if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
	ISNVIDIA=true
else
	ISNVIDIA=false
fi

if [[ $ISNVIDIA = true ]]; then
	ln -sf ~/.config/hypr/nvidia-env.conf ~/.config/hypr/nvidia-env
	echo "Using nvidia. Installing nvidia-specific packages..."
	yay -S --needed --noconfirm --sudoloop "${nvidia[@]}"
	sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
	sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
	echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
	yay -S --needed --noconfirm --sudoloop hyprland-nvidia
else
	ln -sf ~/.config/hypr/empty.conf ~/.config/hypr/nvidia-env
	echo "Not using nvidia."
	yay -S --needed --noconfirm --sudoloop hyprland
fi

# Prep
echo "Installing prep stage packages..."
yay -S --needed --noconfirm --sudoloop "${prep[@]}"

echo "Installing rust toolchains..."
rustup toolchain install stable
rustup toolchain install nightly

echo "Enabling bluetooth..."
sudo systemctl enable --now bluetooth

echo "Enabling tlp..."
sudo systemctl enable --now tlp

# Packages
echo "Installing packages..."
yay -S --needed --noconfirm --sudoloop "${packages[@]}"

# Nvim
echo "Cloning astronvim config..."
mkdir -p ~/.config/astronvim/lua/user
rm -rf ~/.config/nvim

git clone --depth=1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
git clone https://github.com/adriannic/astronvim-config ~/.config/astronvim/lua/user

# Autologin
echo "Setting up autologin..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo "[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin adriannic %I $TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null

# Hack to be able to open term apps with wofi
echo "Creating symlink to kitty from gnome-terminal..."
sudo ln -s /usr/bin/kitty /usr/bin/gnome-terminal

# Cava
echo "Activating snd_aloop module for cava..."
sudo modprobe snd_aloop

# Flatpak
echo "Setting up flathub..."
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Steam
echo "Installing steam..."
flatpak --user install flathub com.valvesoftware.Steam

echo "Installation complete!"
