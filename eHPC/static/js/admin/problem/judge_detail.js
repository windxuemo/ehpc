$(function () {
    if (op == "edit") {
        $('input[name=solution]').eq(!sol).attr('checked', 'true');
        var selected_classifies = [];
        for(var k in data){
            selected_classifies.push(data[k]);
        }
        $(".selectpicker").selectpicker('val', selected_classifies);
    }

    var edt1 = custom_simplemde({
        element: $("#content-editor").get(0),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    var edt2 = custom_simplemde({
        element: $("#analysis-editor").get(0),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });
});