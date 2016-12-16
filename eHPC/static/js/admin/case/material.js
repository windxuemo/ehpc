$(document).ready(function () {

    $("#all-select").click(function () {
        var obj = this;
        $("#material-table-body").find("input").prop("checked", $(obj).prop("checked"));
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

    var template = $("#template").parent().html();
    $("#template").remove();

    $("#dropz").dropzone({
        url: location.href,
        maxFiles: 10,
        maxFilesize: 512,
        acceptedFiles: ".c,.cpp,.py,.f",
        autoProcessQueue: true,
        previewTemplate: template,
        previewsContainer: "#previews", // Define the container to display the previews
        clickable: ".fileinput-button", // Define the element that should be used as click trigger to select files.
        dictInvalidFileType: "不支持的文件类型",
        dictMaxFilesExceeded: "文件数量不能超过10个",
        dictFileTooBig: "文件大小不能超过512",
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
