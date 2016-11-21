$(function () {
    for(var k in data){
        $("#classify"+data[k].toString()).eq(0).attr('checked', 'true');
    }

    var edt1 = new SimpleMDE({
        element: document.getElementById("content-editor"),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    var edt2 = new SimpleMDE({
        element: document.getElementById("analysis-editor"),
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });

    $("#form").submit(function (evt) {
        var array = edt1.value().split('*');
        var solution = {}, count = 0;
        for (var i = 1; i < array.length; i += 2)
            solution[(count++).toString()] = array[i];
        solution["len"] = count;

        $("#solution-editor").val(JSON.stringify(solution));
    });
});