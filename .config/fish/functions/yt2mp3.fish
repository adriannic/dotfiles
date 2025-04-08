function yt2mp3 --wraps='yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 --cookies-from-browser firefox' --description 'alias yt2mp3=yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 --cookies-from-browser firefox'
  yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 --cookies-from-browser firefox $argv
        
end
