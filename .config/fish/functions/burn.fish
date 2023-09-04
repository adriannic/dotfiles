function burn --description 'burn iso onto device'
  sudo dd bs=4M if=$argv[1] of=$argv[2] conv=fsync oflag=direct status=progress
end
