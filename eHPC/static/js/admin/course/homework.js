$(document).ready(function () {
    var edt = drop_img_simplemde(new SimpleMDE({
        element: $("#homework-description")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    }));

    $("#homework-create-btn").click(function () {
        $("#homework-op").val("create");
        $("#homework-title").val("");
        $("#homework-deadline").val("");
        $("#homework-submitable1").attr("checked","checked");
        $("#homework-submitable2").removeAttr("checked");
        $("#homework-description").val("");
        edt.value("");
    });

    $('#homework-save-btn').click(function () {
        if (edt.value() == "" || edt.value() == null) {
            alert("请编辑作业内容");
            return;
        }
        $("#homework-description")[0].innerHTML = edt.value();
        $("#homework-description").val(edt.value());
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
                    if (data['submitable'] == '0') {
                        $("#homework-submitable1").attr("checked","checked");
                        $("#homework-submitable2").removeAttr("checked");
                    }
                    else {
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
});/**
 * Created by YM on 2016/12/26.
 */
