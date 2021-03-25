#!/usr/bin/env bash

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icon to display before the text
# Insert the absolute path of the icon
# Recommended size is 24x24 px
readonly ICON="${DIR}/icons/spotify.png"
readonly ICON_OFFLINE="${DIR}/icons/spotify_offline.png"

if pidof spotify &> /dev/null; then
  # Spotify song's info
  readonly ARTIST=$(bash "${DIR}/spotify.sh" artist | sed 's/&/&#38;/g')
  readonly TITLE=$(bash "${DIR}/spotify.sh" title | sed 's/&/&#38;/g')
  readonly ALBUM=$(bash "${DIR}/spotify.sh" album | sed 's/&/&#38;/g')
  #readonly ART=$(bash "${DIR}/spotify.sh" art | sed 's/&/&#38;/g') 

  ARTIST_TITLE=$(echo "${ARTIST} - ${TITLE}")

  # window id
  readonly WINDOW_ID=$(wmctrl -l | grep "${ARTIST_TITLE}\|Spotify Premium" | awk '{print $1}')
  
  # Proper length handling
  readonly MAX_CHARS=100
  readonly STRING_LENGTH="${#ARTIST_TITLE}"
  readonly CHARS_TO_REMOVE=$(( STRING_LENGTH - MAX_CHARS ))
  [ "${#ARTIST_TITLE}" -gt "${MAX_CHARS}" ] \
    && ARTIST_TITLE="${ARTIST_TITLE:0:-CHARS_TO_REMOVE} …"

  # Panel
  if [[ $(file -b "${ICON}") =~ PNG|SVG ]]; then
    INFO="<img>${ICON}</img>"
    INFO+="<txt>"
    INFO+="${ARTIST_TITLE}"
    INFO+="</txt>"
  else
    INFO="<txt>"
    INFO+="${ARTIST_TITLE}"
    INFO+="</txt>"
  fi

  INFO+="<click>xdotool windowactivate ${WINDOW_ID}</click>"

  # Tooltip
  MORE_INFO="<tool>"
  MORE_INFO+="Artist ....: ${ARTIST}\n"
  MORE_INFO+="Album ..: ${ALBUM}\n"
  MORE_INFO+="Title ......: ${TITLE}"
  MORE_INFO+="</tool>"
else
  # Panel
  if [[ $(file -b "${ICON}") =~ PNG|SVG ]]; then
    INFO="<img>${ICON_OFFLINE}</img>"
    #INFO+="<txt>"
    #INFO+="Offline"
    #INFO+="</txt>"
  else
    INFO="<txt>"
    INFO+="Offline"
    INFO+="</txt>"
  fi

  # Tooltip
  MORE_INFO="<tool>"
  MORE_INFO+="Spotify is not running"
  MORE_INFO+="</tool>"

  INFO+="<click>spotify</click>"
fi

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
