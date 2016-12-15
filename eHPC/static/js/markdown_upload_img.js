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

    simplemde.codemirror.on('drop', function (editor, e) {
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
        $.ajax({
            type: "post",
            url: $(simplemde.element).data('img-upload-url'),
            data: img,
            processData : false,
            contentType : false,
            success: function (data) {
                if (data["status"] == "success") {
                    editor.replaceRange("![](" + data['uri'] + ")", {line: editor.getCursor().line, ch: editor.getCursor().ch});
                }
                else {
                    alert("上传图片失败");
                }
            }
        });
    });
    return simplemde;
}

