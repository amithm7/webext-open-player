# Open In mpv Web Ext

Opens URLs (video) in mpv

## Requirements

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
