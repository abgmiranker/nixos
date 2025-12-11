{ pkgs, ... }:
let
  appdrawer = pkgs.writeShellScriptBin "appdrawer" ''
  #!/usr/bin/env bash

  #Specify a display with -m
  rofi -show drun -m "DP-5" -config "$HOME/.config/rofi/appdrawer.rasi"
'';
  #overviewlistener depends on killall, jq
  #waybar becomes .waybar-wrapped?
  overviewlistener = pkgs.writeShellScriptBin "overviewlistener" ''
#!/usr/bin/env bash

# Listen for overview events and signal waybar
niri msg --json event-stream | jq -c --unbuffered 'select(.OverviewOpenedOrClosed != null)' | \
while read -r event; do
    #killall -SIGUSR1 waybar
    killall -SIGUSR1 .waybar-wrapped
done
'';
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
#!/usr/bin/env bash

# Menu options
shutdown="$(printf '\uf16f')"
reboot="$(printf '\ue5d5')"
suspend="$(printf '\uef44')"
logout="$(printf '\ue9ba')"

# Give options to rofi and save choice
chosen="$(echo -e "$shutdown\n$reboot\n$suspend\n$logout" | rofi -dmenu -config "$HOME/.config/rofi/powermenu.rasi" )"

case "$chosen" in
  "$shutdown")
    poweroff
    ;;
  "$reboot")
    reboot
    ;;
  "$suspend")
    systemctl suspend
    ;;
  "$logout")
    niri msg action quit
    ;;
  *)
    exit 0
    ;;
esac
'';
  volumeosd = pkgs.writeShellScriptBin "volumeosd" ''
#!/usr/bin/env bash

step=0.01

case "$1" in
    up)
        wpctl set-mute @DEFAULT_SINK@ 0
        wpctl set-volume @DEFAULT_SINK@ "0.01+"
        ;;
    down)
        wpctl set-mute @DEFAULT_SINK@ 0
        wpctl set-volume @DEFAULT_SINK@ "0.01-"
        ;;
    mute)
        wpctl set-mute @DEFAULT_SINK@ toggle 
        ;;
esac

# Get volume and status and send to mako
volume=$(wpctl get-volume @DEFAULT_SINK@)
vol_value=$(echo "$volume" | awk '{print $2 * 100}')
vol_status=$(echo "$volume" | cut -d" " -f3)

if [ "$vol_status" = "[MUTED]" ]; then
    notify-send -a "muted" -h int:value:"$vol_value" ""
    exit 0
fi

notify-send -a "volume" -h int:value:"$vol_value" ""
'';
  colorwaybar = pkgs.writeShellScriptBin "colorwaybar" ''
  #!/usr/bin/env bash

  image="$1"
  waybar_css="$HOME/.config/waybar/color.css"

  touch "$waybar_css"

  # Calculate brightness
  brightness=$(convert "$image" -resize 500x500^ -format "%[fx:int(mean*100)]" info:)
  if (( brightness < 48 )); then
      color="rgba(255,255,255,0.8)"  
  else
      color="rgba(0,0,0,0.8)"        
  fi

  # Write color to css
  echo "@define-color primary $color;" > "$waybar_css"
'';
  bgselector = pkgs.writeShellScriptBin "bgselector" ''
    #!/usr/bin/env bash

    wall_dir="$HOME/Pictures/wallpapers"
    cache_dir="$HOME/.cache/thumbnails/bgselector"

    mkdir -p "$wall_dir"
    mkdir -p "$cache_dir"

    # Generate thumbnails
    find "$wall_dir" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | while read -r imagen; do
	filename="$(basename "$imagen")"
	thumb="$cache_dir/$filename"
	if [ ! -f "$thumb" ]; then
		magick convert -strip "$imagen" -thumbnail x540^ -gravity center -extent 262x540 "$thumb"
	fi
    done

    # List wallpapers with icons for rofi
    wall_selection=$(ls "$wall_dir" | while read -r A; do echo -en "$A\x00icon\x1f$cache_dir/$A\n"; done | rofi -dmenu -config "$HOME/.config/rofi/bgselector.rasi")

    # Set wallpaper and update waybar color
    if [ -n "$wall_selection" ]; then
	swww img "$wall_dir/$wall_selection" -t grow --transition-duration 1 --transition-fps 75
	sleep 0.2
	colorwaybar "$wall_dir/$wall_selection"
	exit 0
    else
	exit 1
    fi
  '';
in {
  home.packages = [ 
    bgselector 
    colorwaybar
    appdrawer
    powermenu
    volumeosd
    overviewlistener
  ];
}
