$(document).ready(function () {
    $('#dtp').datetimepicker({
        format: "yyyy-mm-dd hh:ii",
        weekStart: 1,
        todayBtn:  1,
        autoclose: 1,
        todayHighlight: 1,
        startView: 2,
        forceParse: 0
    });
    var edt = custom_simplemde({
        element: $("#homework-description")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    edt.codemirror.on('refresh', function() {
        if (edt.isFullscreenActive()) {
            $('body').addClass('simplemde-fullscreen');
        }
        else {
            $('body').removeClass('simplemde-fullscreen');
        }
    });

    $("#homework-create-btn").click(function () {
        $("#homework-op").val("create");
        $("#homework-title").val("");
        $("#homework-deadline").val("");
        $("#dtp .form-control").val("");
        $("#homework-description").val("");
        edt.value("");
    });

    $('#homework-save-btn').click(function () {
        if ($("#homework-title").val() == "" || $("#homework-title").val() == null) {
            show_invalid_info("#homework-edit-info","#homework-edit-info span","请编辑作业标题");
            return;
        }
        if ($("#homework-title").val().length > 6) {
            show_invalid_info("#homework-edit-info","#homework-edit-info span","作业标题过长（长度不超过256）");
            return;
        }
        if ($("#homework-deadline").val() == "" || $("#homework-deadline").val() == null) {
            show_invalid_info("#homework-edit-info","#homework-edit-info span","请选择作业截止日期");
            return;
        }
        if (edt.value() == "" || edt.value() == null) {
            show_invalid_info("#homework-edit-info","#homework-edit-info span","请编辑作业内容");
            return;
        }

        $("#homework-description")[0].innerHTML = edt.value();
        $("#homework-description").val(edt.value());
        $.ajax({
            type: "post",
            url: location.href,
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

    var obj = null;
    $("#homework-item-list").find("a[name=del-btn]").click(function () {
        obj = this;
        $("#del-warning").modal("show");
    });

    $("#del-confirm").click(function () {
        $.ajax({
            type: "post",
            url: location.href,
            data: {
                op: 'del',
                homework_id: $(obj).parent().parent().data('homework_id')
            },
            async: false,
            success: function (data) {
                if (data["status"] == "success") {
                    $(obj).parent().parent().remove();
                    $("#del-warning").modal("hide");
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
            url: location.href,
            data: {
                op: "data",
                homework_id: $(obj).parent().parent().data('homework_id')
            },
            success: function (data) {
                if (data["status"] == "success") {
                    $("#homework-op").val("edit");
                    $("#homework-title").val(data['title']);
                    $("#homework-deadline").val(data['deadline']);
                    $("#dtp .form-control").val(data['deadline']);
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
});/**
 * Created by YM on 2016/12/26.
 */
