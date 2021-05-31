function openPlayer (player, url) {
    switch (player) {
        case 'mpv':
            chrome.tabs.update({ 'url': 'ytdl://' + url });
            console.log("open mpv");
            break;
        case 'vlc':
            chrome.tabs.update({ 'url': 'vlc://' + url });
            console.log("open vlc");
            break;
    }
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

// Create menu
// Storage keys in namespace 'local' (storage area)
chrome.storage.local.get({
    defaultPlayer: 'mpv',
    players: {
        mpv: true,
        vlc: true
    }
}, function (items) {
    if(items.players.mpv) {
        createMenu('mpv');
    }
    if(items.players.vlc) {
        createMenu('vlc');
    }
});

// Create listeners for menu items and extension button
// every time this script loads, as this script is not persistent.
chrome.storage.local.get({
    defaultPlayer: 'mpv',
    players: {
        mpv: true,
        vlc: true
    }
}, function (items) {
    chrome.browserAction.onClicked.addListener((tab) => {
        openPlayer(items.defaultPlayer, tab.url);
    });
    chrome.contextMenus.onClicked.addListener(function (info, tab) {
        let player = info.menuItemId.split('-')[0];
        let url = "";
        if (info.menuItemId == player + "-page") {
            url = tab.url;
        } else if (info.menuItemId == player + "-link") {
            url = info.linkUrl;
        } else if (info.menuItemId == player + "-video") {
            url = info.srcUrl;
        }
        openPlayer(player, url);
    });
});

// When options are changed
chrome.storage.onChanged.addListener(function (changes, namespace) {
    chrome.runtime.reload();
    for (var key in changes) {
        var storageChange = changes[key];
        console.log('Storage key', key, ' in namespace ',namespace, ' changed. ' +
            'Old value was ', storageChange.oldValue,' new value is ', storageChange.newValue);
    }
});
