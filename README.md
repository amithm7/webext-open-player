# Open In mpv Web Ext

Opens URLs (video) in mpv or vlc

## Requirements

### Open in MPV

**`ytdl://` URL's needs to be associated with mpv for this extension to work**

On linux, this can be done with creating a `.desktop` file in `~/.local/share/applications/`

Example (`mpv-ytdl.desktop`):

```sh
[Desktop Entry]
Type=Application
Name=mpv-ytdl
Exec=mpv %U
Terminal=false
NoDisplay=true
MimeType=x-scheme-handler/ytdl
```

And then run `update-desktop-database ~/.local/share/applications`

You can test if this works with
`xdg-mime query default x-scheme-handler/ytdl`
and it should show you the respective `.desktop` file.

### Open in VLC:

**`vlc://` URL handler needs to be created**

Create `vlc-handler.desktop` in `~/.local/share/applications/` or `/usr/share/applications/`

```sh
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
