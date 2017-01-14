$(function () {
    if (op == "edit") {
        $('input[name=solution]').eq(!sol).attr('checked', 'true');
        var selected_classifies = [];
        for(var k in data){
            selected_classifies.push(data[k]);
        }
        $(".selectpicker").selectpicker('val', selected_classifies);
    }
});