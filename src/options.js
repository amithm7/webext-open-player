// Saves options to chrome.storage
function save_options() {
    var defaultPlayer = document.getElementById('default').value;
    var mpvCheck = document.getElementById('mpv').checked;
    var vlcCheck = document.getElementById('vlc').checked;

    chrome.storage.local.set({
        defaultPlayer: defaultPlayer,
        players: {
            mpv: mpvCheck,
            vlc: vlcCheck
        }
    }, function () {
        // Update status to let user know options were saved.
        var status = document.getElementById('status');
        status.textContent = 'Saved!';
        setTimeout(function () {
            status.textContent = '';
        }, 3000);
    });
}

// Restores select box and checkbox state using the preferences
// stored in chrome.storage.
function restore_options() {
    // Use default values are specified here
    chrome.storage.local.get({
        defaultPlayer: 'mpv',
        players: {
            mpv: true,
            vlc: true
        }
    }, function (items) {
        document.getElementById('default').value = items.defaultPlayer;
        document.getElementById('mpv').checked = items.players.mpv;
        document.getElementById('vlc').checked = items.players.vlc;
    });
}
document.addEventListener('DOMContentLoaded', restore_options);
document.getElementById('save').addEventListener('click', save_options);
