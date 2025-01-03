# Web Extension: Open In Player

Opens URLs (video) in mpv or vlc media players

## Installation

### 1. Install your media players

Supported players:

- mpv
- vlc

### 2. Get the Extension

- FireFox: Install extension from [Mozilla Add-Ons](https://addons.mozilla.org/en-US/firefox/addon/open-in-player/) if not already.
- Chromium Browsers: Download this repo and load unpacked from and point to the `src` directory here.

### 3. Setup

> [!IMPORTANT]
> For mpv setup, `ytdl://` URL's need to be associated with mpv

> [!IMPORTANT]
> For vlc setup, `vlc://` URL handler needs to be created, such URLs be associate with it

#### 3a. System wide (Linux)

Download and run the [install.sh](./install.sh) script. Option to choose players will be provided.

```sh
chmod +x ./install.sh
./install.sh
```

#### 3b. mpv can be setup for Firefox browser only:

- Navigate to address `about:support`.
- Look for an entry _Profile Directory_ or _Profile Folder_ (on Windows).
- Open this directory or folder to find `handlers.json` file.
- Open the file to edit it (you may need to format it to be readable,
	you could do that with your text editor or an online tool like
	jsonlint.com).
- In this JSON file, there are few schemes defined, you will need to add
	a new one named `ytdl` with and empty object `{}` at the end of
	`schemes` object value, like this:
	```jsonc
	"schemes": {
		// <other schemes here already>,
		"ytdl": {}
	}
	```
- Restart Firefox.
- Navigate to address `about:preferences#general` and find the
	_Applications_ section. Here, you will find the `ytdl` entry.
- Choose the _Action_ for the `ytdl` entry as to open with `mpv`.
