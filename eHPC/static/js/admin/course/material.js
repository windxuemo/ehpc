$(document).ready(function () {
    $("#material-table-body").find("input").prop("checked", false);

    $("#all-select").click(function () {
        var obj = this;
        $("#material-table-body").find("input").prop("checked", $(obj).prop("checked"));
    });

    $("#upload-material-btn").click(function () {
        $.ajax({
            url: location.href,
            type: "post",
            data: new FormData($('#course-material-form')[0]),
            cache: false,
            contentType: false,
            processData: false,
            success: function (data) {
                if(data.status=="success"){
                    alert("上传成功");
                }
                else{
                    alert("上传失败 \n" + data['info']);
                }
            },
            error: function (data) {
                alert("上传失败" + data['info']);
            }
        });
        location.reload();
    });

    $("#del-material-btn").click(function () {
        var array = [];
        $("#material-table-body").find("input").each(function () {
            if (this.checked) {
                $(this).parent().parent().remove();
                array.push($(this).parent().parent().data("material_id"));
            }
        });

        $.ajax({
            type: "post",
            url: location.href,
            data: {
                op: "del",
                material_id: array
            },
            success: function (data) {
                if(data.status=="success"){
                    alert("删除成功");
                    $("#file-manage-panel").find("input").prop("checked", false);
                }
                else{
                    alert("删除失败");
                }
            }
        });
    });

    $("#dialog-close-btn").click(function () {
        $("#upload-status").hide();
    });

    $("#local-upload-btn").click(function () {
        $("#upload-status").show();
    });

});

$(function () {
    // Get the template HTML and remove it from the doumenthe template HTML and remove it from the doument
    var previewNode = document.querySelector("#template");
    previewNode.id = "";
    var previewTemplate = previewNode.parentNode.innerHTML;
    previewNode.parentNode.removeChild(previewNode);

    var myDropzone = new Dropzone($("#dropzone").get(0), { // Make the whole body a dropzone
        url: location.href, // Set the url
        thumbnailWidth: 80,
        thumbnailHeight: 80,
        parallelUploads: 20,
        previewTemplate: previewTemplate,
        // autoQueue: false, // Make sure the files aren't queued until manually added
        previewsContainer: "#previews", // Define the container to display the previews
        clickable: ".fileinput-button" // Define the element that should be used as click trigger to select files.
    });

    myDropzone.on("addedfile", function(file) {
        // Hookup the start button
        file.previewElement.querySelector(".start").onclick = function() { myDropzone.enqueueFile(file); };
    });

    // Update the total progress bar
    myDropzone.on("totaluploadprogress", function(progress) {
        document.querySelector("#total-progress .progress-bar").style.width = progress + "%";
    });

    myDropzone.on("sending", function(file) {
        // Show the total progress bar when upload starts
        document.querySelector("#total-progress").style.opacity = "1";
        // And disable the start button
        file.previewElement.querySelector(".start").setAttribute("disabled", "disabled");
    });

    // Hide the total progress bar when nothing's uploading anymore
    myDropzone.on("queuecomplete", function(progress) {
        document.querySelector("#total-progress").style.opacity = "0";
    });

    myDropzone.on("queuecomplete", function(file) {
        location.reload();
    });

    // Setup the buttons for all transfers
    // The "add files" button doesn't need to be setup because the config
    // `clickable` has already been specified.
    document.querySelector("#actions .start").onclick = function() {
        myDropzone.enqueueFiles(myDropzone.getFilesWithStatus(Dropzone.ADDED));
    };
    document.querySelector("#actions .cancel").onclick = function() {
        myDropzone.removeAllFiles(true);
    };
});