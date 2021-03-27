chrome.browserAction.onClicked.addListener((tab) => {
    chrome.tabs.update({'url':'ytdl://' + tab.url});
});
