$(function () {
    if (op == "edit") {
        var selected_classifies = [];
        for(var k in data){
            selected_classifies.push(data[k]);
        }
        $(".selectpicker").selectpicker('val', selected_classifies);
    }


    var edt1 = custom_simplemde({
        element: $("#content-editor")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    var edt2 = custom_simplemde({
        element: $("#solution-editor")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    var edt3 = custom_simplemde({
        element: $("#analysis-editor")[0],
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });
});