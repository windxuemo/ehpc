$(document).ready(function () {
    $("#all-homework-select").click(function () {
        var obj = this;
        $("#homework-table-body").find("input[type=checkbox]").prop("checked", $(obj).prop("checked"));
    });

    var array = [];
    $("#del-homework-btn").click(function () {
        $("#homework-table-body").find("input").each(function () {
            if (this.checked) {
                $(this).parent().parent().remove();
                array.push($(this).parent().parent().data("upload_id"));
            }
        });
        if (array.length == 0) {
            alert_modal("请勾选要删除的文件");
        }
        else {
            $("#del-warning").modal("show");
        }
    });

    $("#del-confirm").click(function () {
        $.ajax({
            type: "post",
            url: location.href,
            data: {
                op: "del",
                upload_id: array
            },
            success: function (data) {
                if(data.status=="success"){
                    $("#homework-manage-panel").find("input").prop("checked", false);
                    $("#del-warning").modal("hide");
                }
                else{
                    alert_modal("删除失败,文件不存在！");
                }
            }
        });
    });

    $("#download-homework-btn").click(function () {
        array = [];
        $("#homework-table-body").find("input[type='checkbox']").each(function () {
            if (this.checked) {
                array.push($(this).parent().parent().data("upload_id"));
            }
        });
        if (array.length == 0) {
            alert_modal("请选择要下载的文件！");
        }

        else {
            $.ajax({
                type: "post",
                url: location.href,
                data: {
                    op: "download",
                    upload_id: array
                },
                success: function (data) {
                    if(data.status=="success"){
                        $("#homework-manage-panel").find("input").prop("checked", false);
                        var zip_path = $("#homework-table-body input[name='zip-path']").val();
                        var a = document.createElement('a');
                        a.href = zip_path;
                        a.target = '_parent';
                        // Use a.download if available, it prevents plugins from opening.
                        if ('download' in a) {
                            var timestamps = new Date().getTime();
                            a.download = '' + data['course_title'] + '_' + data['homework_title'] + '_' + timestamps + '.zip';
                        }
                        // Add a to the doc for click to work.
                        (document.body || document.documentElement).appendChild(a);
                        if (a.click) {
                            a.click(); // The click method is supported by most browsers.
                        }
                        else {
                            $(a).click(); // Backup using jquery
                        }
                        // Delete the temporary link.
                        a.parentNode.removeChild(a);
                        $("#all-homework-select").prop("checked", "");
                        $("#homework-table-body").find("input[type=checkbox]").prop("checked", "");
                    }
                },
                error: function() {
                    alert_modal("文件下载失败");
                }
            });
        }
    });
});/**
 * Created by YM on 2016/12/26.
 */
