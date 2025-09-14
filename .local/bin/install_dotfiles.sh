#!/bin/bash

# Set default applications for various file types

# Image files - set imv as default image viewer
for type in image/png image/jpeg image/jpg image/gif image/webp image/tiff image/bmp image/svg+xml; do
    xdg-mime default imv.desktop $type
done

# PDF files - set zathura as default PDF viewer
xdg-mime default org.pwmt.zathura.desktop application/pdf

# Text files - set your preferred text editor
for type in text/plain text/x-shellscript text/x-python text/x-csrc text/x-c++src; do
    xdg-mime default nvim.desktop $type
done

# Video files - set mpv as default video player
for type in video/mp4 video/x-msvideo video/quicktime video/x-matroska video/webm; do
    xdg-mime default mpv.desktop $type
done

# Audio files - set mpv as default audio player
for type in audio/mpeg audio/ogg audio/wav audio/flac audio/x-vorbis+ogg; do
    xdg-mime default mpv.desktop $type
done

echo "Default applications have been set successfully!"