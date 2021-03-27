function openInMpv (url) {
    chrome.tabs.update({ 'url': 'ytdl://' + url });
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

chrome.contextMenus.onClicked.addListener(function (info, tab) {
    if (info.menuItemId == "open-page") {
        openInMpv(tab.url);
    } else if (info.menuItemId == "open-link") {
        openInMpv(info.linkUrl);
    }
});
