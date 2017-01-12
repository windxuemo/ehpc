function delete_tag(e) {
    var existed_tags = $("input[name='tags']")[0].value;
    var cur_tag = $(e).next()[0].innerText;
    var tmp = cur_tag + ";";
    if (existed_tags.indexOf(tmp) >= 0) {
        $("input[name='tags']")[0].value = existed_tags.replace(tmp, "");
    }
    else {
        $("input[name='tags']")[0].value = existed_tags.replace(cur_tag, "");
    }
    var left_tags = $("input[name='tags']")[0].value;
    if (left_tags[left_tags.length - 1] == ";") {
        $("input[name='tags']")[0].value = left_tags.substr(0, left_tags.length - 1);
    }
    $(e).parent().remove();
    var txt = $(".case-tag-display")[0].innerHTML;
    var reg = /\S/;
    if (!reg.test(txt)) {
        $(".case-tag-display").addClass("hide");
    }
}

$(function () {
    /* 提交案例信息 */
    $("#submit-case-info").click(function() {
        $("textarea")[0].innerHTML = simplemde.value();
        var p_instance = $('#case-info-form').parsley();
        p_instance.validate();
        if (p_instance.isValid()) {
            $.ajax({
                type: "post",
                url: post_to,
                data: new FormData($('#case-info-form')[0]),
                cache: false,
                processData: false,
                contentType: false,
                success: function (data) {
                    if (data["status"] == "success") {
                        $("#case-edit-status").removeClass("hide");
                        $("#case-edit-status .case-edit-status-info")[0].innerHTML = "修改成功";
                    }
                    else {
                        $("#case-edit-status").removeClass("hide");
                        $("#case-edit-status .case-edit-status-info")[0].innerHTML = "修改失败";
                    }
                }
            });
        }
    });

    $("#case-edit-status .close").click(function() {
        $("#case-edit-status").addClass("hide");
    });

    $("#add-tag-btn").click(function () {
        var tag = $(".case-tags")[0].value;
        var reg = /\S/;
        if (!reg.test(tag)) {
            alert("标签名为空，请重新输入！");
        }
        else {
            var tag_value = $("input[name='tags']")[0].value;
            if (tag_value) {
                tag_value += ";";
            }
            tag_value += tag;
            $("input[name='tags']")[0].value = tag_value;

            var tag_label = "<h1 class='btn btn-info'>" +
                "<button type='button' class='close' onclick='delete_tag(this);'>&times;</button><span>" +
                tag + "</span></h1>";
            $(".case-tag-display")[0].innerHTML += tag_label;
            $(".case-tag-display").removeClass("hide");
        }
        $(".case-tags")[0].value = "";
    });
});
