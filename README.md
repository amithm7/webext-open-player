# Web Extension: Open In Player

Opens URLs (video) in mpv or vlc

## Requirements

### Open in MPV

**`ytdl://` URL's needs to be associated with mpv for this extension to work**

1. System wide association:
	- On linux, this can be done with creating a `.desktop` file in
		`~/.local/share/applications/`
	- Example (`mpv-ytdl.desktop`):
		```desktop
		[Desktop Entry]
		Type=Application
		Name=mpv-ytdl
		Exec=mpv %U
		Terminal=false
		NoDisplay=true
		MimeType=x-scheme-handler/ytdl
		```
	- And then run `update-desktop-database ~/.local/share/applications`
	- You can test if this works with
		`xdg-mime query default x-scheme-handler/ytdl`
		and it should show you the respective `.desktop` file.

2. For use Firefox browser only:
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

**`vlc://` URL handler needs to be created**

Create `vlc-handler.desktop` in `~/.local/share/applications/` or `/usr/share/applications/`

```desktop
[Desktop Entry]
Type=Application
Name=VLC URL handler
Exec=/usr/share/handlers/vlc-handler %U
Terminal=false
NoDisplay=true
MimeType=x-scheme-handler/vlc
```

And then run `update-desktop-database ~/.local/share/applications`

Create file handler `/usr/share/handlers/vlc-handler` or `~/.local/share/handlers/vlc-handler` (but specify full path in `.desktop` file)

```sh
#!/usr/bin/env bash

request="${1#*://}"             # Remove schema from url (vlc://)

vlc "$request"
```

Make it executable: `sudo chmod +x /usr/share/handlers/vlc-handler`
