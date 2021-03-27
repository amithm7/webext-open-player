# Open In mpv Web Ext

Opens URLs (video) in mpv

## Requirements

**`ytdl://` URL's needs to be associated with mpv for this extension to work**

On linux, this can be done with creating a `.desktop` file in `~/.local/share/applications/`

Example (`mpv.desktop`):

```sh
[Desktop Entry]
Type=Application
Name=mpv
Exec=mpv %U
Terminal=false
NoDisplay=true
MimeType=x-scheme-handler/ytdl
```

And then run `update-desktop-database ~/.local/share/applications`
