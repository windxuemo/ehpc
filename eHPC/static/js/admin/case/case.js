$(function () {
    var simplemde = new SimpleMDE({
        element: document.getElementById("target-editor"),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    window.$my = {
        simplemde: simplemde
    }

    simplemde.codemirror.on('drop', function (editor, e) {
        upload_img(editor, e, post_to);
    });

    function delete_tag(e) {
        var existed_tags = $("input[name='tags']")[0].value;
        cur_tag = $(e).next()[0].innerText;
        //alert(existed_tags);
        tmp = cur_tag + ";"
        if (existed_tags.indexOf(tmp) >= 0) {
            $("input[name='tags']")[0].value = existed_tags.replace(tmp, "");
        }
        else {
            $("input[name='tags']")[0].value = existed_tags.replace(cur_tag, "");
        }
        left_tags = $("input[name='tags']")[0].value;
        if (left_tags[left_tags.length - 1] == ";") {
            $("input[name='tags']")[0].value = left_tags.substr(0, left_tags.length - 1);
        }

        $(e).parent().remove();
        txt = $(".case-tag-display")[0].innerHTML;
        var reg = /\S/;
        if (!reg.test(txt)) {
            $(".case-tag-display").addClass("hide");
        }
    }

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
            //alert($("input[name='tags']")[0].value);

            tag_label = "<h1 class='btn btn-info'>" +
                "<button type='button' class='close' onclick='delete_tag(this);'>&times;</button><span>" +
                tag + "</span></h1>";
            $(".case-tag-display")[0].innerHTML += tag_label;
            $(".case-tag-display").removeClass("hide");
        }
        $(".case-tags")[0].value = "";
    });
});

/* 提交案例信息 */
$(function () {
    $('#submit-case-info').click(function () {
        var x = $my.simplemde.value();
        if (x == null || x == "") {
            alert("请输入案例描述");
            return false;
        }

        /* Ajax 提交数据, 更新结果反馈给当前页面。*/
        // var $data = $("form").serialize();
        // alert($data);
        // $.ajax({
        //     url: this.href,
        //     method: "post",
        //     dataType: "json",
        //     data: $data,
        //     contentType: 'application/json;charset=UTF-8',
        //     success: function (data) {
        //         if(data.status=='success'){
        //
        //         }
        //         else{
        //             alert("保存失败, 请稍后重试");
        //         }
        //     },
        //     error: function () {
        //         alert("保存信息出错, 请稍后重试");
        //     },
        // });
        return false;
    });
});