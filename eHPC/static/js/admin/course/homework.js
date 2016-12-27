$(document).ready(function () {
    $("#all-homework-select").click(function () {
        var obj = this;
        $("#homework-table-body").find("input[type=checkbox]").prop("checked", $(obj).prop("checked"));
    });

    $("#homework-create-btn").click(function () {
        $("#homework-op").val("create");
        $("#homework-title").val("");
        $("#homework-deadline").val("");
        $("#homework-submitable1").attr("checked","checked");
        $("#homework-submitable2").attr("checked","");
        $("#homework-description").val("");
        edt.value("");
    });

    $('#homework-save-btn').click(function () {
        if (edt.value() == "" || edt.value() == null) {
            alert("请编辑作业内容");
            return;
        }
        $("#homework-description")[0].innerHTML = edt.value();
        $.ajax({
            type: "post",
            url: homework_url,
            cache: false,
            processData: false,
            contentType: false,
            data: new FormData($('#course-homework-form')[0]),
            success: function (data) {
                if (data["status"] == "success") {
                    alert("保存成功");
                    location.reload();
                }
                else {
                    alert("保存失败");
                }
            }
        });
    });

    $("#homework-item-list").find("a[name=del-btn]").click(function () {
        var obj = this;
        $.ajax({
            type: "post",
            url: homework_url,
            data: {
                op: 'del',
                homework_id: $(obj).parent().parent().data('homework_id')
            },
            async: false,
            success: function (data) {
                if (data["status"] == "success") {
                    $(obj).parent().parent().remove();
                }
                else {
                    alert("删除失败");
                }
            }
        });
    });

    $("#homework-item-list").find("a[name=edit-btn]").click(function () {
        var obj = this;
        $.ajax({
            type: "post",
            url: homework_url,
            data: {
                op: "data",
                homework_id: $(obj).parent().parent().data('homework_id')
            },
            success: function (data) {
                if (data["status"] == "success") {
                    $("#homework-op").val("edit");
                    $("#homework-title").val(data['title']);
                    $("#homework-deadline").val(data['deadline']);
                    if (data['submitable'] == '0') {alert("000");
                        $("#homework-submitable1").attr("checked","checked");
                        $("#homework-submitable2").removeAttr("checked");
                    }
                    else {alert("111");
                        $("#homework-submitable2").attr("checked","checked");
                        $("#homework-submitable1").removeAttr("checked");
                    }
                    edt.value(data['description']);
                    $("#homework-description")[0].innerHTML = data['description'];
                    $("#homework-id").val($(obj).parent().parent().data('homework_id'));
                }
                else {
                    alert("获取信息失败");
                }
            }
        });
    });

    $("#del-homework-btn").click(function () {
        var array = [];
        $("#homework-table-body").find("input").each(function () {
            if (this.checked) {
                $(this).parent().parent().remove();
                array.push($(this).parent().parent().data("upload_id"));
            }
        });

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
                }
                else{
                    alert("删除失败,文件不存在！");
                }
            }
        });
    });

    $("#download-homework-btn").click(function () {
        var array = [];
        $("#homework-table-body").find("input[type='checkbox']").each(function () {
            if (this.checked) {
                array.push($(this).parent().parent().data("upload_id"));
            }
        });

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
                        a.download = 'homework_' + data['homework_id'] + '.zip';
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
                }
            },
            error: function() {
                alert("文件下载失败");
            }
        });
    });
});/**
 * Created by YM on 2016/12/26.
 */
