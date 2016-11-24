$(document).ready(function () {
    $("#all-select").click(function () {
        if (this.checked) {
            $("#material-table-body").find("input").each(function () {
                this.checked = true;
            });
        }
        else {
            $("#material-table-body").find("input").each(function () {
                this.checked = false;
            });
        }
    });

    $("#upload-material-btn1,#upload-material-btn2").click(function (e) {
        var material_form;
        if (e.target.id == "upload-material-btn1") {
            material_form = $('#course-material-form1')[0];
        }
        else {
            material_form = $('#course-material-form2')[0];
        }
        $.ajax({
            url: url,
            type: "post",
            data: new FormData(material_form),
            cache: false,
            contentType: false,
            processData: false,
            xhr: function(){ //获取ajaxSettings中的xhr对象，为它的upload属性绑定progress事件的处理函数
                myXhr = $.ajaxSettings.xhr();
                if(myXhr.upload){ //检查upload属性是否存在
                    //绑定progress事件的回调函数
                    myXhr.upload.addEventListener('progress',progressHandlingFunction, false);
                }
                return myXhr; //xhr对象返回给jQuery使用
            },
            success: function (data) {
                if(data.status=="success"){
                    alert("上传成功");
                }
                else{
                    alert("上传失败 " + data['info']);
                }
                location.reload();
            },
            error: function (data) {
                alert("上传失败");
            }
        });
    });

    $("#del-material-btn").click(function () {
        var array = [];
        $("#material-table-body").find("input").each(function () {
            if (this.checked) {
                $(this).parent().parent().remove();
                array.push($(this).parent().parent().data("material_id"));
            }
        });

        $.ajax({
            type: "post",
            url: url,
            data: {
                op: "del",
                material_id: array
            },
            success: function (data) {
                if(data.status=="success"){
                    alert("删除成功");
                    $("#file-manage-panel").find("input").prop("checked", false);
                }
                else{
                    alert("删除失败");
                }
            }
        });
    });
});

//上传进度回调函数：
function progressHandlingFunction(e) {
    if (e.lengthComputable) {
        $('progress').attr({value : e.loaded, max : e.total}); //更新数据到进度条
        var percent = e.loaded/e.total*100;
        $('#progress').html(percent.toFixed(2) + "%");
    }
}
