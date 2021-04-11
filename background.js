function openInMpv (url) {
    chrome.tabs.update({ 'url': 'ytdl://' + url });
    console.log("open mpv");
}

function openInVLC (url) {
    chrome.tabs.update({ 'url': 'vlc://' + url });
    console.log("open vlc");
}

function createMenu (player) {
    chrome.contextMenus.create({
        id: player + "-page",
        title: player + " - Open page",
        contexts: ["page"]
    });

    chrome.contextMenus.create({
        id: player + "-link",
        title: player + " - Open link",
        contexts: ["link"]
    });

    chrome.contextMenus.create({
        id: player + "-video",
        title: player + " - Open video",
        contexts: ["video"]
    });
}

function listenMenu (player) {
    chrome.contextMenus.onClicked.addListener(function (info, tab) {
        let url = "";
        if (info.menuItemId == player + "-page") {
            url = tab.url;
        } else if (info.menuItemId == player + "-link") {
            url = info.linkUrl;
        } else if (info.menuItemId == player + "-video") {
            url = info.srcUrl;
        }
        player == "mpv" ? openInMpv(url) : openInVLC(url);
    });
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
        createMenu('mpv');
        listenMenu('mpv');
    }
    if(items.players.vlc) {
        createMenu('vlc');
        listenMenu('vlc');
    }
});
