#!/usr/bin/env bash

readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# settings
readonly ICON="${DIR}/icons/spotify.png"
readonly ICON_OFFLINE="${DIR}/icons/spotify_offline.png"
readonly DISPALY_TITLE_MAX_LENGTH=20

if pidof spotify &> /dev/null; then
    # Use the command-line Spotify controller to get song infor over dbus
    eval $(${DIR}/sp.sh eval)

    # grab window id 
    WINDOW_ID=$(wmctrl -l | grep "${SPOTIFY_ARTIST} - ${SPOTIFY_TITLE}\|Spotify Premium" | awk '{print $1}')

    # trim title of song 
    DISPLAY_TITLE=$SPOTIFY_TITLE  
    [ "${#DISPLAY_TITLE}" -gt "${DISPALY_TITLE_MAX_LENGTH}" ] && \
      DISPLAY_TITLE="${SPOTIFY_TITLE:0:DISPALY_TITLE_MAX_LENGTH} …"
      
    echo "<img>${ICON}</img>"
    echo "<txt>${SPOTIFY_ARTIST} - ${DISPLAY_TITLE}</txt>"
    echo "<click>xdotool windowactivate ${WINDOW_ID}</click>"
    echo "<tool>Title  : ${SPOTIFY_TITLE}"
    echo "Artist : ${SPOTIFY_ARTIST}"
    echo "Album  : ${SPOTIFY_ALBUM}</tool>"
else 
  echo "<img>${ICON_OFFLINE}</img>"
  echo "<tool>Spotify is not running</tool>"
  echo "<click>spotify</click>"
fi
