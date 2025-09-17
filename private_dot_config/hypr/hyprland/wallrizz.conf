$WR = WallRizz -n -e -s 81x25 -d $wallpaperDir $themeMode -f "STD.setenv('enableBlur',true)"
$WallRizz = kitty -1 -o allow_remote_control=yes -o background_opacity=$overlay_window_opacity --title=WallRizz $WR
$WallRizzRandom = kitty -1 -o allow_remote_control=yes --class=hidden --title=hidden $WR -r

# WallRizz Grid View
windowrulev2 = float, title:^(WallRizz)$ 
windowrulev2 = size 70% 70%, title:^(WallRizz)$
windowrulev2 = animation slide top, title:^(WallRizz)$
windowrulev2 = dimaround, title:^(WallRizz)$
windowrulev2 = pin, title:^(WallRizz)$
windowrulev2 = center 1, title:^(WallRizz)$
windowrulev2 = bordersize 10, title:^(WallRizz)$
windowrulev2 = rounding 20, title:^(WallRizz)$


# WallRizz Array View
windowrulev2 = float, title:^(WallRizz)$ 
windowrulev2 = animation slide top, title:^(WallRizz)$
windowrulev2 = dimaround, title:^(WallRizz)$
windowrulev2 = pin, title:^(WallRizz)$
windowrulev2 = center 1, title:^(WallRizz)$
windowrulev2 = size 70% 30%, title:^(WallRizz)$
windowrulev2 = bordersize 10, title:^(WallRizz)$
windowrulev2 = rounding 20, title:^(WallRizz)$

# WallRizz Stack View
windowrulev2 = float, title:^(WallRizz)$ 
windowrulev2 = size 363 981, title:^(WallRizz)$
windowrulev2 = move 80% 5%, title:^(WallRizz)$
windowrulev2 = animation slide right, title:^(WallRizz)$
windowrulev2 = dimaround, title:^(WallRizz)$
windowrulev2 = pin, title:^(WallRizz)$
windowrulev2 = bordersize 10, title:^(WallRizz)$

# Key binds
bindd = ,f3, Apply wallpaper preset, exec, $WallRizz
bindd = $mainMod, f3, Apply random wallpaper, exec, $WallRizzRandom
