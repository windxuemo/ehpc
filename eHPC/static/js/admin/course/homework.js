function hide_validate_info(ele) {
    $(ele)[0].innerHTML = "";
}

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

    $('input[id=homework-appendix]').change(function() {
        $(".unsolved").remove();
        var file_list = $("#homework-appendix")[0].files
        var file_count = file_list.length;
        if (file_count > 1) {
            str = "已选择" + file_count + "个文件";
            $('#filenameCover').val(str);
        }
        else {
            $('#filenameCover').val($(this).val());
        }
        for (var i=0; i<file_count; ++i) {
            var uploadFilehtml = ''
            + '<div id="" class="alert alert-info alert-dismissable unsolved" role="alert">'
            + '<i class="es-icon es-icon-description status-icon"></i>'
            + '<span>' + file_list[i].name + '</span>'
            + '</div>';
            $("#homework-appendix-list").append(uploadFilehtml);
        }
    });

    $(".delete-appendix").click(function () {
        var curr_div = $(this).parent().parent()
        if (curr_div.hasClass("uploaded")) {
            var appendix_id = curr_div.data("appendix-id");
            $.ajax({
                type: "post",
                url: location.href,
                data: {
                    op: "del",
                    appendix_id: appendix_id
                },
                success: function (data) {
                    if(data.status == "success"){
                        curr_div.remove();
                    }
                    else{
                        var str = curr_div.data("appendix-name") + "删除失败，请稍后重试！";
                        alert(str);
                    }
                }
            });
        }
    });

});/**
 * Created by YM on 2016/12/26.
 */
