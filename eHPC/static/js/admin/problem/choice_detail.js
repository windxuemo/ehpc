$(document).ready(function () {

    if(op == "edit") {
        for(var k in data){
            $("#classify"+data[k].toString()).eq(0).attr('checked', 'true');
        }
        //需编辑题目的答案

        oldAnswer = oldAnswer.split(';');
        for (i = 0; i < oldAnswer.length; i++) {
            $("#options").find("input[value=" + (oldAnswer[i].charCodeAt(0)-'A'.charCodeAt(0)).toString() + "]").attr('checked', true);
        }
        //需编辑题目,是否为不定项
        if (type == 2) {
            $("input[name=if-undef]").attr('checked', true);
        }
    }

    var simplemde = drop_img_simplemde();

    var edt = drop_img_simplemde(new SimpleMDE({
        element: document.getElementById("analysis-editor"),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    }));

    var c_type = 0;

    //删除选项
    $("#options").find(".btn.btn-default").each(function () {
        $(this).click(function () {
            var len = $("#options").find(".btn.btn-default").length;
            if(len==2){
                alert("选项过少");
                return;
            }

            $(this).parent().parent().remove();//移除当前项

            //修改选项序号
            var number = 0;
            $("#options").find(".input-group-addon").each(function () {
                var str = $(this).find('span[data-id=index-letter]').eq(0).text();
                str = str.substr(0, str.length - 1) + String.fromCharCode("A".charCodeAt(0) + number);
                $(this).find('span[data-id=index-letter]').text(str);
                number++;
            });
            number = 0;
            $("#options").find("input[name=option_index]").each(function () {
                $(this).val(number++);
            });
        });
    });

    //添加选项
    $("#add-options").click(function () {
        var temp = $("#options").find(".input-group").last();
        var t = temp.clone(true);
        temp.after(t);

        //新选项内容为空
        t.find("input[name=options]").val("");
        var v = t.find('input[name=option_index]');
        v.val((Number(v.val())+1).toString());
        v.prop('checked', false);
        //修改新选项序号为原来最后一个序号加1
        t.find(".input-group-addon").each(function () {
            var str = $(this).find('span[data-id=index-letter]').eq(0).text();
            str = str.substr(0, str.length - 1) + String.fromCharCode(str.charCodeAt(str.length - 1) + 1);
            $(this).find('span[data-id=index-letter]').text(str);
        });
    });

    //保存提交
    $("#save-problem").click(function () {
        var count = 0;
        $("input[name=classify]").each(function () {
            if (this.checked == true) {
                count++;
            }
        });
        if (count == 0) {
            alert("请至少选则一个知识点");
            return;
        }

        var choiceDetail = simplemde.value();
        if (choiceDetail.length == 0) {
            alert("题干不能为空");
            return;
        }

        var solution = [];

        count = 0;
        $("#options").find("input[name=option_index]").each(function () {
            if (this.checked == true) {
                count++;
                solution.push(String.fromCharCode((Number($(this).val()) + 'A'.charCodeAt(0))));
            }
        });
        if (count == 0) {
            alert("请选择正确答案");
            return;
        }

        if (count == 1) c_type = 0;//单选
        else c_type = 1;//多选
        if ($("input[name=if-undef]")[0].checked) c_type = 2;

        solution = solution.join(';'); //答案

        var content = {};   //题干+选项
        content['title'] = choiceDetail;
        content['len'] = $("#options").find("input[name=option_index]").length;

        var hasEmptyChoice = false;
        $("input[name=options]").each(function () {
            if ($(this).val() == "") {
                alert("请填写所有选项");
                hasEmptyChoice = true;
            }
            content[$(this).parent().find('input[name=option_index]').eq(0).val().toString()] = $(this).val();
        });
        if (hasEmptyChoice) return;

        var form = $("#form");
        form.find("input[name=content]").val(JSON.stringify(content));
        form.find("input[name=solution]").val(solution);
        form.find("input[name=analysis]").val(edt.value());
        form.find("input[name=type]").val(c_type);
        form.submit();
    });
});