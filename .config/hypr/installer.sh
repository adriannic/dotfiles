#! /bin/bash

prep=(
	archlinux-xdg-menu
	base-devel
	cliphist
	frameworkintegration
	gtk3
	kdecoration
	nwg-look
	pipewire
	pipewire-alsa
	pipewire-audio
	pipewire-pulse
	qt5ct
	qt5-svg
	qt5-wayland
	qt6ct
	qt6-multimedia-ffmpeg
	qt6-wayland
	rustup
	tlp
	udiskie
	upower
	wireplumber
)

nvidia=(
	libva
	libva-nvidia-driver
	linux-headers
	nvidia
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
	dolphin
	dosfstools
	eog
	exfat-utils
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
	kitty
	kvantum
	kvantum-qt5
	kvantum-theme-catppuccin-git
	less
	lightly-kf5-git
	lightly-kf6-git
	lsd
	luarocks
	lutris
	man-db
	mangal-bin
	mangohud
	man-pages
	megacmd
	mpv
	mpvpaper
	mypy
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
	protonup-qt-bin
	python-pywalfox
	pywal-git
	qalculate-gtk
	qbittorrent
	ranger
	rclone
	reflector
	ripgrep
	ripgrep-all
	slimbookbattery
	starship
	steam-devices
	steamtinkerlaunch
	swaylock-effects
	swaync-git
	swayosd-git
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
	vim
	wev
	whatsdesk-bin
	wine
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
echo "Using nvidia?"
select yn in "Yes" "No"; do
	case $yn in
	Yes)
		ISNVIDIA=true
		break
		;;
	No)
		ISNVIDIA=false
		break
		;;
	*)
		echo "Invalid option"
		;;
	esac
done

if [[ $ISNVIDIA = true ]]; then
	echo "Using nvidia. Installing nvidia-specific packages..."
	yay -S --needed --noconfirm --sudoloop "${nvidia[@]}"
	sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
	sudo mkinitcpio -P
	echo -e "options nvidia-drm modeset=1 fbdev=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
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

echo "Setting up archlinux-xdg-menu..."
XDG_MENU_PREFIX=arch- kbuildsycoca6

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

echo "Installation complete!"
