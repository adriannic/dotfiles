#! /bin/bash

prep=(
	base-devel
	qt5-wayland
	qt5ct
	qt6-wayland
	qt6ct
	qt5-svg
	gtk3
	nwg-look
	pipewire
	pipewire-audio
	pipewire-alsa
	pipewire-pulse
	wireplumber
	jq
	wl-clip-persist-git
	wl-clipboard
	cliphist
	rustup
	bluez
	bluez-utils
	udiskie
)

nvidia=(
	linux-headers
	nvidia-dkms
	nvidia-settings
	libva
	libva-nvidia-driver-git
)

packages=(
	kitty
	dunst
	eww-wayland
	swaylock-effects
	swww
	wofi
	wlogout
	xdg-desktop-portal
	xdg-desktop-portal-hyprland
	hyprshot
	btop
	firefox
	mpv
	pulsemixer
	brightnessctl
	blueberry
	starship
	ttf-firacode-nerd
	nerd-fonts-inter
	ani-cli
	bat
	ark
	cava
	discord
	lsd
	fish
	flatpak
	gamemode
	gamescope
	github-cli
	neovim
	hyprpicker-git
	jq
	jre-openjdk
	kcalc
	luarocks
	lutris
	mangal-bin
	mangohud
	rclone
	neofetch
	networkmanager
	npm
	obs-studio
	partitionmanager
	playerctl
	prismlauncher
	polkit-kde-agent
	qbittorrent
	ranger
	reflector
	ripgrep
	rsync
	spotify-adblock
	stacer
	sweet-theme-full-git
	telegram-desktop
	time
	tldr
	unrar
	unzip
	v4l2loopback-dkms
	wev
	whatsapp-nativefier
	xdg-utils
	xdg-user-dirs
	ydotool
	yt-dlp
	zathura
	zathura-pdf-mupdf
	zip
	pywal-git
	python-pywalfox
	swappy
	megasync-bin
	sweet-folders-icons-git
	watershot
	swayosd-git
	pavucontrol
	dolphin
	dolphin-plugins
	zoxide
	ripgrep-all
	ncdu
)

sudo pacman -S --needed --noconfirm base-devel git

# Installing yay
git clone https://aur.archlinux.org/yay.git
(
	cd yay
	makepkg -si --noconfirm --needed
)
rm -rf yay

if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
	ISNVIDIA=true
else
	ISNVIDIA=false
fi

if [[ $ISNVIDIA = true ]]; then
	yay -S --needed --noconfirm "${nvidia[@]}"
	sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
	sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
	echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
  yay -S --needed --noconfirm hyprland-nvidia
else
  yay -S --needed --noconfirm hyprland
fi

# Prep
yay -S --needed --noconfirm "${prep[@]}"

rustup toolchain install stable
rustup toolchain install nightly

sudo systemctl enable --now bluetooth

# Configs
git clone --bare https://github.com/adriannic/dotfiles "$HOME"/.dotfiles
git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" checkout -f

if [[ $ISNVIDIA = true ]]; then
  ln -sf ~/.config/hypr/nvidia-env.conf ~/.config/hypr/nvidia-env
else
  ln -sf ~/.config/hypr/empty.conf ~/.config/hypr/nvidia-env
fi

# Packages
yay -S --needed --noconfirm "${packages[@]}"

# Nvim
mkdir -p ~/.config/astronvim/lua/user
rm -rf ~/.config/nvim

git clone --depth=1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim
git clone https://github.com/adriannic/astronvim-config ~/.config/astronvim/lua/user

# Autologin
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo "[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin adriannic %I $TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf

# Hack to be able to open term apps with wofi
sudo ln -s /usr/bin/kitty /usr/bin/gnome-terminal
