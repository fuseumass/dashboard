$(document).on('turbolinks:load', function () {
    if (!(page.controller() === 'event_applications' && page.action() === 'new' || page.action() === 'edit')) {
        return;
    }
});


$(document).on('ready', function () {
    if (!(page.controller() === 'event_applications' && page.action() === 'create' || page.action() === 'update')) {
        return;
    }
});


function updateProjectImageFileLabel() {
    var fileLabel = document.getElementsByClassName('custom-file-label')[0];
    var resumeFileField = document.getElementById('project_projectimage');
    if(resumeFileField) {
        var pathArray = resumeFileField.value.split('\\');
        var fileName = pathArray[pathArray.length-1];
        fileLabel.innerHTML = fileName;
    }
}

function updateRequestImageFileLabel() {
    var fileLabel = document.getElementsByClassName('custom-file-label')[0];
    var resumeFileField = document.getElementById('request_requestimage');
    if(resumeFileField) {
        var pathArray = resumeFileField.value.split('\\');
        var fileName = pathArray[pathArray.length-1];
        fileLabel.innerHTML = fileName;
    }
}
