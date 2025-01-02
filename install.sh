#!/usr/bin/env sh

DESKTOP_DIR="$HOME/.local/share/applications"
# DESKTOP_DIR="/usr/share/applications"
DESKTOP_FILE_PATH_MPV="$DESKTOP_DIR/mpv-ytdl.desktop"
DESKTOP_FILE_PATH_VLC="$DESKTOP_DIR/vlc-handler.desktop"
# VLC_HANDLER_PATH="$HOME/.local/share/handlers/vlc-handler"
VLC_HANDLER_PATH="/usr/share/handlers/vlc-handler" # OR at $HOME/.local/share/handlers/vlc-handler

setup_mpv() {
	echo "Creating $DESKTOP_FILE_PATH_MPV"
	[ ! -f "$DESKTOP_FILE_PATH_MPV" ] &&
		cat <<-'EOF' >"$DESKTOP_FILE_PATH_MPV" || echo 'mpv-ytdl.desktop file exists already'
			[Desktop Entry]
			Type=Application
			Name=mpv-ytdl
			Exec=mpv %U
			Terminal=false
			NoDisplay=true
			MimeType=x-scheme-handler/ytdl
		EOF
}

setup_vlc() {
	# Create vlc-handler
	echo "Creating $VLC_HANDLER_PATH"
	mkdir -p "$(dirname "$VLC_HANDLER_PATH")" ||
		sudo mkdir -p "$(dirname "$VLC_HANDLER_PATH")" ||
		{
			echo "Failed to verify / create directory"
			exit 1
		}

	[ ! -f "$VLC_HANDLER_PATH" ] &&
		cat <<-'EOF' | sudo tee "$VLC_HANDLER_PATH" >/dev/null || echo 'VLC handler exits already'
			#!/usr/bin/env bash
			request="${1#*://}"             # Remove schema from url (vlc://)
			vlc "$request"
		EOF

	test -x "$VLC_HANDLER_PATH" || chmod +x "$VLC_HANDLER_PATH" || sudo chmod +x "$VLC_HANDLER_PATH"

	# Create vlc-handler.desktop
	echo "Creating $DESKTOP_FILE_PATH_VLC"
	[ ! -f "$DESKTOP_FILE_PATH_VLC" ] &&
		cat <<-'EOF' | sed "s|{EXEC}|${VLC_HANDLER_PATH}|" >"$DESKTOP_FILE_PATH_VLC" || echo 'vlc-handler.desktop file exists already'
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
