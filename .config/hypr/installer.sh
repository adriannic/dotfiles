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
	udiskie
	wireplumber
	wl-clip-persist-git
	wl-clipboard
)

nvidia=(
	libva
	libva-nvidia-driver-git
	linux-headers
	nvidia-dkms
	nvidia-settings
)

packages=(
	ani-cli
	ark
	bat
	blueberry
	brightnessctl
	btop
	cava
	discord
	dolphin
	dolphin-plugins
	dunst
	eww-wayland
	firefox
	fish
	flatpak
	gamemode
	gamescope
	github-cli
	hyprpicker-git
	hyprshot
	jq
	jre-openjdk
	kcalc
	kitty
	lsd
	luarocks
	lutris
	mangal-bin
	mangohud
	megasync-bin
	mpv
	ncdu
	neofetch
	neovim
	nerd-fonts-inter
	networkmanager
	npm
	obs-studio
	partitionmanager
	pavucontrol
	playerctl
	polkit-kde-agent
	prismlauncher
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
	swappy
	swaylock-effects
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
	watershot
	wev
	whatsapp-nativefier
	wlogout
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
