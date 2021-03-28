function openInMpv (url) {
    chrome.tabs.update({ 'url': 'ytdl://' + url });
    console.log("open mpv");
}

function openInVLC (url) {
    chrome.tabs.update({ 'url': 'vlc://' + url });
    console.log("open vlc");
}

chrome.storage.sync.get({
    defaultPlayer: 'mpv',
    players: {
        mpv: true,
        vlc: true
    }
}, function (items) {
    chrome.browserAction.onClicked.addListener((tab) => {
        if(items.defaultPlayer == 'mpv') {
            openInMpv(tab.url);
        } else if (items.defaultPlayer == 'vlc') {
            openInVLC(tab.url);
        }
    });
    if(items.players.mpv) {
        chrome.contextMenus.create({
            id: "open-page-mpv",
            title: "Open page with mpv",
            contexts: ["page"]
        });

        chrome.contextMenus.create({
            id: "open-link-mpv",
            title: "Open link with mpv",
            contexts: ["link"]
        });
        chrome.contextMenus.onClicked.addListener(function (info, tab) {
            if (info.menuItemId == "open-page-mpv") {
                openInMpv(tab.url);
            } else if (info.menuItemId == "open-link-mpv") {
                openInMpv(info.linkUrl);
            }
        });
    }
    if(items.players.vlc) {
        chrome.contextMenus.create({
            id: "open-page-vlc",
            title: "Open page with VLC",
            contexts: ["page"]
        });

        chrome.contextMenus.create({
            id: "open-link-vlc",
            title: "Open link with VLC",
            contexts: ["link"]
        });

        chrome.contextMenus.onClicked.addListener(function (info, tab) {
            if (info.menuItemId == "open-page-vlc") {
                openInVLC(tab.url);
            } else if (info.menuItemId == "open-link-vlc") {
                openInVLC(info.linkUrl);
            }
        });
    }
});
