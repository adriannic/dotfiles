function yayy --description 'update everything'
  yay --noconfirm &&
  yay -Yc --noconfirm &&
  sudo rm -rf /var/cache/pacman/pkg/*
  yay -Sc --noconfirm &&
  flatpak update --noninteractive &&
  flatpak uninstall --unused --noninteractive &&
  rustup update
end
