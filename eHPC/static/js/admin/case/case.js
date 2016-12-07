document.write("<script language=javascript src='/static/js/markdown_upload_img.js'></script>");
$(document).ready(function () {
    var simplemde = new SimpleMDE({
        element: document.getElementById("target-editor"),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    simplemde.codemirror.on('drop', function (editor, e) {
        upload_img(editor, e, post_to);
    });

    function validateForm() {
        var x = simplemde.value();
        if (x == null || x == "") {
            alert("请输入案例描述");
            return false;
        }
    }
    function delete_tag(e) {
        existed_tags = $("input[name='tags']")[0].value;
        cur_tag = $(e).next()[0].innerText;
        //alert(existed_tags);
        tmp = cur_tag + ";"
        if (existed_tags.indexOf(tmp)>=0) {
            $("input[name='tags']")[0].value = existed_tags.replace(tmp,"");
        }
        else {
            $("input[name='tags']")[0].value = existed_tags.replace(cur_tag,"");
        }
        left_tags = $("input[name='tags']")[0].value;
        if(left_tags[left_tags.length-1] == ";") {
            $("input[name='tags']")[0].value = left_tags.substr(0,left_tags.length-1);
        }

        $(e).parent().remove();
        txt = $(".case-tag-display")[0].innerHTML;
        var reg = /\S/;
        if(!reg.test(txt)) {
            $(".case-tag-display").addClass("hide");
        }
    }

    $("#add-tag-btn").click(function() {
        tag = $(".case-tags")[0].value;
        var reg = /\S/;
        if (!reg.test(tag)) {
            alert("标签名为空，请重新输入！");
        }
        else {
            tag_value = $("input[name='tags']")[0].value;
            if (tag_value) {
                tag_value += ";";
            }
            tag_value += tag;
            $("input[name='tags']")[0].value = tag_value;
            //alert($("input[name='tags']")[0].value);

            tag_label = "<h1 class='btn btn-info'>"+
                        "<button type='button' class='close' onclick='delete_tag(this);'>&times;</button><span>"+
                        tag+"</span></h1>";
            $(".case-tag-display")[0].innerHTML += tag_label;
            $(".case-tag-display").removeClass("hide");
        }
        $(".case-tags")[0].value = "";
    });
});

