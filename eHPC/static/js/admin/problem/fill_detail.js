$(function () {
    if (op == "edit") {
        var selected_classifies = [];
        for (var k in data) {
            selected_classifies.push(data[k]);
        }
        $(".selectpicker").selectpicker('val', selected_classifies);
    }

    $("#form").submit(function (evt) {
        var array = edt1.value().split('*');
        var solution = {}, count = 0;
        for (var i = 1; i < array.length; i += 2)
            solution[(count++).toString()] = array[i];
        solution["len"] = count;

        $("#solution-editor").val(JSON.stringify(solution));
    });
});
