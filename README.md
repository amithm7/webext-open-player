# Web Extension: Open In Player

Opens URLs (video) in mpv or vlc

## Requirements

### Open in MPV

> [!IMPORTANT]
> `ytdl://` URL's needs to be associated with mpv

#### System wide association on Linux, run the following commands:

```sh
# Create the directory if not already
mkdir -p ~/.local/share/applications

MPV_YTDL_DESKTOP_PATH="~/.local/share/applications/mpv-ytdl.desktop"

# Create desktop file
[ ! -f "$MPV_YTDL_DESKTOP_PATH" ] && echo '[Desktop Entry]
Type=Application
Name=mpv-ytdl
Exec=mpv %U
Terminal=false
NoDisplay=true
MimeType=x-scheme-handler/ytdl
' > "$MPV_YTDL_DESKTOP_PATH" || echo 'mpv-ytdl.desktop file exists already'

update-desktop-database ~/.local/share/applications

# Test if successfully setup
[ "$(xdg-mime query default x-scheme-handler/ytdl)" = "mpv-ytdl.desktop" ] && echo 'Successfully setup mpv for ytdl://'
```

#### For Firefox browser only:

- Navigate to address `about:support`.
- Look for an entry _Profile Directory_ or _Profile Folder_ (on Windows).
- Open this directory or folder to find `handlers.json` file.
- Open the file to edit it (you may need to format it to be readable,
	you could do that with your text editor or an online tool like
	jsonlint.com).
- In this JSON file, there are few schemes defined, you will need to add
	a new one named `ytdl` with and empty object `{}` at the end of
	`schemes` object value, like this:
	```json
	"schemes": {
		// <other schemes here already>,
		"ytdl": {}
	}
	```
- Restart Firefox.
- Navigate to address `about:preferences#general` and find the
	_Applications_ section. Here, you will find the `ytdl` entry.
- Choose the _Action_ for the `ytdl` entry as to open with `mpv`.

### Open in VLC:

> [!IMPORTANT]
> `vlc://` URL handler needs to be created, such URLs be associate with it

#### System wide association on Linux, run the following commands:

```sh
# Create the directory if not already OR use /usr/share/applications/
mkdir -p ~/.local/share/applications

VLC_YTDL_DESKTOP_PATH="~/.local/share/applications/vlc-handler.desktop"
VLC_HANDLER_PATH="/usr/share/handlers/vlc-handler"

# Create desktop file
[ ! -f "$VLC_YTDL_DESKTOP_PATH" ] && echo '[Desktop Entry]
Type=Application
Name=VLC URL handler
Exec=/usr/share/handlers/vlc-handler %U
Terminal=false
NoDisplay=true
MimeType=x-scheme-handler/vlc
' > "$VLC_YTDL_DESKTOP_PATH" || echo 'vlc-handler.desktop file exists already'

update-desktop-database ~/.local/share/applications

# Test if successfully setup
[ "$(xdg-mime query default x-scheme-handler/vlc)" = "vlc-handler.desktop" ] && echo 'Successfully setup vlc-handler for vlc://'

# Create VLC handler OR at ~/.local/share/handlers/vlc-handler` (but specify full path in `.desktop` file)
[ ! -f "$VLC_HANDLER_PATH" ] && echo '#!/usr/bin/env bash

request="${1#*://}"             # Remove schema from url (vlc://)

vlc "$request"
' > "$VLC_HANDLER_PATH" || echo 'VLC handler exits alredy'

# Make it executable
sudo chmod +x "$VLC_HANDLER_PATH"
```
