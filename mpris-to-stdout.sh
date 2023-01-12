player=$(dbus-send --print-reply --dest=org.freedesktop.DBus  /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep -oP 'org.mpris.MediaPlayer2.*' | sed 's/"//')

if [ -z "$player" ];then
	echo 'No player found'
	exit 1
fi

#discard all mpris sources except the first one
player=$(echo $player | sed s/\ .*//)

lastLine=""
while true;do
	metadata=$(dbus-send --print-reply --dest=$player /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata)
	title=$(echo $metadata | grep -oP 'xesam:title.*' | sed 's/xesam:title" variant string//' | awk -F \" '{print $2}')
	artist=$(echo $metadata | grep -oP 'xesam:artist.*' | sed 's/xesam:artist" variant array \[ string //' | awk -F \" '{print $2}')
	
	line="$artist | $title"
	
	if [ "$line" != "$lastLine" ] && [ -n "$line" ];then
		echo $line
	fi

	lastLine=$line

	sleep 2
done
