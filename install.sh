#!/usr/bin/env sh

confirm_y() {
	read -r -p "${1:-Are you sure?}  [Y/n]" -n 1 response
	echo # new line
	case "$response" in
	[nN]) false ;;
	*) true ;;
	esac
}

# ------------------------------------------------------------------------------

DESKTOP_DIR="$HOME/.local/share/applications"
# DESKTOP_DIR="/usr/share/applications"
DESKTOP_FILE_PATH_MPV="$DESKTOP_DIR/mpv-ytdl.desktop"
DESKTOP_FILE_PATH_VLC="$DESKTOP_DIR/vlc-handler.desktop"

# HANDLER_DIR="$HOME/.local/share/handlers"
HANDLER_DIR="/usr/share/handlers"
HANDLER_PATH_MPV="mpv"
HANDLER_PATH_VLC="$HANDLER_DIR/vlc-handler"

setup_mpv() {
	# Create mpv-handler
	# HANDLER_PATH_MPV="$HANDLER_DIR/mpv-ytdl"
	# echo "Creating $HANDLER_PATH_MPV"
	# mkdir -p "$HANDLER_DIR" ||
	# 	sudo mkdir -p "$HANDLER_DIR" ||
	# 	{
	# 		echo "Failed to verify / create directory"
	# 		exit 1
	# 	}

	# ([ ! -f "$HANDLER_PATH_MPV" ] || confirm_y "File exists. Overwrite?") &&
	# 	cat <<-'EOF' | sudo tee "$HANDLER_PATH_MPV" >/dev/null || echo 'not created'
	# 		#!/usr/bin/env sh
	# 		# request="${1#*://}"             # Remove schema from url (ytdl://)
	# 		request="$1"
	# 		konsole --noclose -e 'bash -c "echo \"args: '$@'\"; echo \"request: '$request'\"; mpv '$request'"'
	# 		# konsole --noclose -e "mpv $request"
	# 		# (mpv "$request")
	# 	EOF

	# test -x "$HANDLER_PATH_MPV" || chmod +x "$HANDLER_PATH_MPV" || sudo chmod +x "$HANDLER_PATH_MPV"

	# Create mpv-handler.desktop
	echo "Creating $DESKTOP_FILE_PATH_MPV"
	([ ! -f "$DESKTOP_FILE_PATH_MPV" ] || confirm_y "File exists. Overwrite?") &&
		cat <<-'EOF' | sed "s|{EXEC}|${HANDLER_PATH_MPV}|" >"$DESKTOP_FILE_PATH_MPV" || echo 'not created'
			[Desktop Entry]
			Type=Application
			Name=MPV URL handler
			Exec={EXEC} %U
			Terminal=false
			NoDisplay=true
			MimeType=x-scheme-handler/ytdl
		EOF
}

setup_vlc() {
	# Create vlc-handler
	echo "Creating $HANDLER_PATH_VLC"
	mkdir -p "$HANDLER_DIR" ||
		sudo mkdir -p "$HANDLER_DIR" ||
		{
			echo "Failed to verify / create directory"
			exit 1
		}

	([ ! -f "$HANDLER_PATH_VLC" ] || confirm_y "File exists. Overwrite?") &&
		cat <<-'EOF' | sudo tee "$HANDLER_PATH_VLC" >/dev/null || echo 'not created'
			#!/usr/bin/env bash
			request="${1#*://}"             # Remove schema from url (vlc://)
			vlc "$request"
		EOF

	test -x "$HANDLER_PATH_VLC" || chmod +x "$HANDLER_PATH_VLC" || sudo chmod +x "$HANDLER_PATH_VLC"

	# Create vlc-handler.desktop
	echo "Creating $DESKTOP_FILE_PATH_VLC"
	([ ! -f "$DESKTOP_FILE_PATH_VLC" ] || confirm_y "File exists. Overwrite?") &&
		cat <<-'EOF' | sed "s|{EXEC}|${HANDLER_PATH_VLC}|" >"$DESKTOP_FILE_PATH_VLC" || echo 'not created'
			[Desktop Entry]
			Type=Application
			Name=VLC URL handler
			Exec={EXEC} %U
			Terminal=false
			NoDisplay=true
			MimeType=x-scheme-handler/vlc
		EOF
}

printf "Choose player to setup: mpv, vlc or both (default): "
read PLAYER
PLAYER="${PLAYER:-both}"

mkdir -p "$DESKTOP_DIR"

if [ "$PLAYER" = "both" ]; then
	setup_mpv
	setup_vlc
elif [ "$PLAYER" = "mpv" ]; then
	setup_mpv
elif [ "$PLAYER" = "vlc" ]; then
	setup_vlc
else
	echo "Invalid player"
	exit 1
fi

update-desktop-database "$DESKTOP_DIR"

echo -e "DONE \n"

echo "Testing..."

# Test if mpv successfully setup
[ "$(xdg-mime query default x-scheme-handler/ytdl)" = "mpv-ytdl.desktop" ] && echo 'mpv is configured for ytdl://'

# Test if vlc successfully setup
[ "$(xdg-mime query default x-scheme-handler/vlc)" = "vlc-handler.desktop" ] && echo 'vlc-handler is configured for vlc://'
