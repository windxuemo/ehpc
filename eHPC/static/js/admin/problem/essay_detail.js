$(function () {
    if (op == "edit") {
        var selected_classifies = [];
        for(var k in data){
            selected_classifies.push(data[k]);
        }
        $(".selectpicker").selectpicker('val', selected_classifies);
    }


    var edt1 = drop_img_simplemde(new SimpleMDE({
        element: $("#content-editor")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    }));

    var edt2 = drop_img_simplemde(new SimpleMDE({
        element: $("#solution-editor")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    }));

    var edt3 = drop_img_simplemde(new SimpleMDE({
        element: $("#analysis-editor")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    }));
});