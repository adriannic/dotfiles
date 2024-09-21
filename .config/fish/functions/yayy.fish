function yayy --description 'update everything'
  yay --noconfirm &&
  yay -Yc --noconfirm &&
  yay -Sc --noconfirm &&
  flatpak update --noninteractive &&
  flatpak uninstall --unused --noninteractive &&
  rustup update
end
