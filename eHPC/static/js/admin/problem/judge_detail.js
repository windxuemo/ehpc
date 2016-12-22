$(function () {
    if (op == "edit") {
        $('input[name=solution]').eq(!sol).attr('checked', 'true');
        for(var k in data){
            $("#classify" + data[k].toString()).eq(0).attr('checked', 'true');
        }
    }

    var edt1 = drop_img_simplemde(new SimpleMDE({
        element: $("#content-editor").get(0),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    }));

    var edt2 = drop_img_simplemde(new SimpleMDE({
        element: $("#analysis-editor").get(0),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    }));
});