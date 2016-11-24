$(function () {
    if (op == "edit") {
        for(var k in data){
            $("#classify" + data[k].toString()).eq(0).attr('checked', 'true');
        }
    }


    var edt1 = new SimpleMDE({
        element: $("#content-editor")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    var edt2 = new SimpleMDE({
        element: $("#solution-editor")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    var edt3 = new SimpleMDE({
        element: $("#analysis-editor")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });
});