function togif --wraps='ffmpeg -i $argv[1] -vf "split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse=new=1:dither=none" -loop -1 $argv[2]' --description 'Convert video to gif without dithering'
  ffmpeg -i $argv[1] -vf "split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse=new=1:dither=none" -loop -1 $argv[2]
        
end
