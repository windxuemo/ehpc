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
                    $("#file-manage-panel").find("input").prop("checked", false);
                }
                else{
                    alert("删除失败");
                }
            }
        });
    });

    // Get the template HTML and remove it from the doumenthe template HTML and remove it from the doument
    var template = $("#template").parent().html();
    $("#template").remove();

    $("#dropz").dropzone({
        url: location.href,
        // maxFiles: 10,
        // maxFilesize: 512,
        // acceptedFiles: ".js,.obj,.dae",
        autoProcessQueue: true,
        previewTemplate: template,
        previewsContainer: "#previews", // Define the container to display the previews
        clickable: ".fileinput-button", // Define the element that should be used as click trigger to select files.
        init: function() {
            this.on("addedfile", function(file) {
                $("#upload-status").show();
            });
            this.on("queuecomplete", function(file) {
                location.reload();
            });
        }
    });

    $("#dialog-close-btn").click(function () {
        $("#upload-status").hide();
    });

});
