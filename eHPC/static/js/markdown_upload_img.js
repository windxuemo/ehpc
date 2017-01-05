//editor: 编辑框本身
//e: event类型，事件本身
//url: 提交到的视图函数url
//提交时，img为图片文件的key，键op表示操作为上传图片
//上传成功后，后台会返回图片地址（例如：static/case/1.png）
//该地址将按照markdown图片格式自动插入到光标处


function drop_img_simplemde() {
    var simplemde = arguments[0]? arguments[0] : new SimpleMDE({
        element: document.getElementById("target-editor"),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    var is_loading = false;

    simplemde.codemirror.on('drop', function (editor, e) {
        if(is_loading){
            alert("请等待当前上传的完成！");
            return;
        }
        is_loading = true;
        var fileList = e.dataTransfer.files;
        if (fileList.length > 1){
            alert('一次只能上传一张图片');
            return false;
        }
        if(fileList[0].type.indexOf('image') === -1){
            alert("不是图片！");
            return false;
        }
        var img = new FormData();
        img.append('img', fileList[0]);
        var pos = {line: editor.getCursor().line, ch: editor.getCursor().ch};
        $("#progress-percent").show();
        $("#progress-text").show();
        $(".progress").slideDown();

        var count = 0;
        $.ajax({
            type: "post",
            url: $(simplemde.element).data('img-upload-url'),
            data: img,
            processData : false,
            contentType : false,
            
            xhr: function(){
                myXhr = $.ajaxSettings.xhr();
                if(myXhr.upload){ 
                    myXhr.upload.addEventListener('progress',function (e) {
                        $(".progress-bar").css("width",(e.loaded/e.total *100).toString() + "%");
                        $("#progress-percent").text(Math.round(e.loaded/e.total *100).toString() + " %");
                    }, false);
                }
                return myXhr;
            },
            
            success: function (data) {
                if (data["status"] == "success") {
                    editor.replaceRange("![](" + data['uri'] + ")", pos);
                }
                else {
                    alert("上传图片失败");
                }
                $("#progress-percent").hide();
                $("#progress-text").hide();
                $(".progress").slideUp();
                $(".progress-bar").css("width","0%");
                $("#progress-percent").text("0 %");

                is_loading = false;
            }
        });
    });
    return simplemde;
}

