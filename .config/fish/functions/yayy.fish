function yayy --description 'update everything'
  yay --noconfirm &&
  yay -Yc --noconfirm &&
  yay -Sc --noconfirm &&
  flatpak update &&
  flatpak uninstall --unused &&
  rustup update &&
  nvim +AstroUpdate +q! +q!
end
