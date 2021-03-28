function openInMpv (url) {
    chrome.tabs.update({ 'url': 'ytdl://' + url });
}

function openInVLC (url) {
    chrome.tabs.update({ 'url': 'vlc://' + url });
}

chrome.browserAction.onClicked.addListener((tab) => {
    openInMpv(tab.url);
});

chrome.contextMenus.create({
    id: "open-page",
    title: "Open page with mpv",
    contexts: ["page"]
});

chrome.contextMenus.create({
    id: "open-link",
    title: "Open link with mpv",
    contexts: ["link"]
});

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
    if (info.menuItemId == "open-page") {
        openInMpv(tab.url);
    } else if (info.menuItemId == "open-link") {
        openInMpv(info.linkUrl);
    } else if (info.menuItemId == "open-page-vlc") {
        openInVLC(tab.url);
    } else if (info.menuItemId == "open-link-vlc") {
        openInVLC(info.linkUrl);
    }
});
