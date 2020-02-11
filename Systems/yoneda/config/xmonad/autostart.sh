## set the key repeat rate
xset r rate 180 80

# unify clipboards
autocutsel -s CLIPBOARD &
autocutsel -s PRIMARY &

# disable touchpad

xinput --list | \
grep TouchPad | \
awk '{print$6}' | \
grep -o '[0-9]\+' | \
xargs xinput --disable

# set default web browser
# commented out because we manage mimeapps.list via home-manager
# xdg-settings set default-web-browser firefox.desktop
