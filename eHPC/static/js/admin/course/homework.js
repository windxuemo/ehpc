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

    edt.codemirror.on('refresh', function() {
        if (edt.isFullscreenActive()) {
            $('body').addClass('simplemde-fullscreen');
        }
        else {
            $('body').removeClass('simplemde-fullscreen');
        }
    });

    edt.codemirror.on("update", function() {
        $("#homework-description")[0].innerHTML = edt.value();
        if (edt.value()) {
            hide_validate_info("#content-errors");
        }
        else {
            $("#content-errors")[0].innerHTML = '<ul class="parsley-errors-list filled" style="color: red;" id="parsley-id-9"><li class="parsley-required">请输入作业内容</li></ul>';
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
        var curr_div = $(this).parent().parent();
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
                        alert_modal(str);
                    }
                }
            });
        }
    });

    // Get the template HTML and remove it from the doumenthe template HTML and remove it from the doument
    var template = $("#template").parent().html();
    $("#template").remove();
    var error = false;
    $("#course-homework-form").dropzone({
        url: location.href,
        maxFiles: 10,
        maxFilesize: 50,
        acceptedFiles: ".mp4,.mkv,.pdf,.zip,.rar",
        autoProcessQueue: false,
        previewTemplate: template,
        uploadMultiple: true,
        parallelUploads: 10,
        previewsContainer: "#previews", // Define the container to display the previews
        clickable: "#select-homework-appendix", // Define the element that should be used as click trigger to select files.
        dictInvalidFileType: "不支持的文件类型",
        dictMaxFilesExceeded: "文件数量不能超过10个",
        dictFileTooBig: "文件大小不能超过50M",
        init: function() {
            var myDropzone = this;
            this.on("addedfile", function(file) {
                $("#upload-status").show();
            });
            this.on("error", function (file) {
               error = true;
               alert_modal("文件上传失败！");
            });
            this.on("queuecomplete", function(file) {
                if (!error) {
                    if(options == "create") {
                        setTimeout(function() {location.href = back_to_list;}, 800);
                    }
                    else {
                        alert_modal("附件上传成功！");
                        $(".close").click(function () {
                           location.reload();
                        });
                    }
                }
            });
            var myDropzone = this;
            this.element.querySelector("input[type=submit]").addEventListener("click", function(e) {
                if (myDropzone.getQueuedFiles().length > 0) {
                    // Make sure that the form isn't actually being sent.
                    var p_instance = $('#course-homework-form').parsley();
                    p_instance.validate();
                    if (p_instance.isValid()) {
                        e.preventDefault();
                        e.stopPropagation();
                        myDropzone.processQueue();
                    }
                }
            });
            $("#upload-status #dialog-mini-btn").click(function () {
                $("#upload-status .modal-body").toggle();
            });
        },
        headers: {
            'X-CSRFToken': csrf_token
        }
    });

    $("#dialog-close-btn").click(function () {
        $("#upload-status").hide();
    });

});/**
 * Created by YM on 2016/12/26.
 */
