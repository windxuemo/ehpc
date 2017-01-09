var tcount=1;
var essay = {};
$('div[data-name=essay]').find('textarea[data-id=target-editor]').each(function () {
    var obj = this;
    essay[tcount.toString()] = custom_simplemde({
        element: obj,
        autosave: true,
        showIcons: ["code", "table"],
        tabSize: 4,
        spellChecker: false
    });
    tcount++;
});

$(document).ready(function () {
    //确认按钮
    $('a[data-id=confirm]').click(function () {
        if(essay[$(this).parent().parent().data('id')].value()!=""){
            if(!ifHasDone[number.toString()]) {//若该题未做过，则标记为已做
                hasDone++;//已完成题目数
                ifHasDone[number.toString()]=true;
            }
            setBarWidth(hasDone);
        }
        $('div[data-id=' + number.toString() + ']').find('div[data-id=solution]').show();
    });

    $('#submit').click(function () {//提交按钮
        clearInterval(clock);
        ifClock = false;
        var date = new Date(0, 0);
        date.setSeconds(second/10);
        var h = date.getHours(), m = date.getMinutes(), s = date.getSeconds();
        $("#submitModal").modal({backdrop: 'static', keyboard: false});
        var done_num =0;
        for(var i=0;i<practice_count;i++){
            if(ifHasDone[(i+1).toString()]==true) done_num++;
        }
        $("#ansResult").text("共 " + practice_count + " 题 " + "已答 "+ done_num.toString()
            + " 题" + " 用时 " + two_char(h) + ":" + two_char(m) + ":" + two_char(s));
    });
});
