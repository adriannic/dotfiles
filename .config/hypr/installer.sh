#! /bin/bash

prep=(
	archlinux-xdg-menu
	base-devel
	cliphist
	cmake
	cpio
	ffmpegthumbs
	firewalld
	frameworkintegration
	gst-libav
	gst-plugins-ugly
	gtk3
	kdecoration
	libvncserver
	nwg-look
	phonon-qt6-mpv
	pipewire
	pipewire-alsa
	pipewire-audio
	pipewire-pulse
	qt5-svg
	qt5-wayland
	qt5ct-kde
	qt6-multimedia-ffmpeg
	qt6-wayland
	qt6ct-kde
	rustup
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
	blueberry
	brightnessctl
	btop
	bun-bin
	candy-icons-git
	cbatticon
	darkly
	discord-canary
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
	hyprpicker
	hyprshot
	jre-openjdk
	kitty
	less
	lsd
	luarocks
	lutris
	man-db
	man-pages
	mangal-bin
	mangohud
	megacmd
	mpv
	mpvpaper
	mypy
	ncdu
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
	npm
	obs-studio
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
	remmina
	ripgrep
	ripgrep-all
	spotify
	starship
	steam-devices
	steamtinkerlaunch
	swaylock-effects
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
	vencord-hook
	vim
	walogram-git
	wayvnc
	wev
	whatsdesk-bin
	wine
	wofi
	xdg-desktop-portal
	xdg-desktop-portal-hyprland
	xdg-user-dirs
	xdg-utils
	yarn
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

echo "Enabling firewalld..."
sudo systemctl enable --now firewalld

echo "Setting up archlinux-xdg-menu..."
XDG_MENU_PREFIX=arch- kbuildsycoca6

# Packages
echo "Installing packages..."
yay -S --needed --noconfirm --sudoloop "${packages[@]}"

# Remove phonon-qt6-vlc
yay -Rns --needed --noconfirm --sudoloop phonon-qt6-vlc

# Hyprland plugins
hyprpm update
hyprpm add https://github.com/alexhulbert/Hyprchroma
hyprpm enable hyprchroma

# Autologin
echo "Setting up autologin..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
echo "[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin adriannic %I $TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null

# Hack to be able to open term apps with wofi
echo "Creating symlink to kitty from gnome-terminal..."
sudo ln -s /usr/bin/kitty /usr/bin/gnome-terminal

# Crack spotify
bash -c 'bash <(curl -sSL https://spotx-official.github.io/run.sh)'

echo "Installation complete!"
