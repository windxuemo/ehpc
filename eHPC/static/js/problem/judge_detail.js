$('div[data-id=solution]').each(function () {
    var sol = $(this).data('solution');
    var temp;
    if (sol == "0"){
        temp = '错误';
    }
    else temp = '正确';
    $(this).data('solution', temp);
    $(this).text("参考答案： " + temp);
});

$(document).ready(function () {
    //确认按钮
    $('a[data-id=confirm]').click(function () {
        var your_solution = [];//用户该题的回答
        $(this).parent().parent().find('ul[data-id=judge-options]').find('li').each(function () {
            if($(this).data('check')=='1'){
                var temp = $(this).find('span[data-id=option]').eq(0).text();
                if(temp == 'T') temp = '正确';
                else if (temp == 'F') temp = '错误';
                your_solution.push(temp);
            }
        });
        if(your_solution.length==0){
            alert_modal("请至少选择一项");
            return false;
        }
        your_solution = your_solution.join(';');

        if(!ifHasDone[number.toString()]) {//若该题未做过，则标记为已做
            hasDone++;//已完成题目数
            ifHasDone[number.toString()]=true;
        }

        var correct_solution = $($(this).parent().parent().find('div[data-id=solution]')[0]).data('solution');

        if(your_solution==correct_solution){//比较正确答案
            corNum[number.toString()]=true;
            $(this).parent().parent().find('img[data-id=choice_wrong]').hide();
            $(this).parent().parent().find('img[data-id=choice_correct]').show();
            setBarWidth(hasDone);
            $('#question-index').find('a[data-id=' + number.toString() +']').eq(0).css('background','#0CCD62');
            $('#question-index').find('a[data-id=' + number.toString() +']').eq(0).css('color','#FFFFFF');
        }
        else{
            corNum[number.toString()]=false;
            setBarWidth(hasDone);
            $(this).parent().parent().find('img[data-id=choice_wrong]').show();
            $(this).parent().parent().find('img[data-id=choice_correct]').hide();
            $('#question-index').find('a[data-id=' + number.toString() +']').eq(0).css('background','#FF3C3C');
            $('#question-index').find('a[data-id=' + number.toString() +']').eq(0).css('color','#FFFFFF');
        }
    });

    $('ul[data-id=judge-options]').find('li').click(function () {
        var flag = false;//当前选项是否已被选择
        if($(this).data('check')=='1'){
            flag = true;
        }

        $(this).parent().children().each(function () {//清空T、F选项选中状态
            $(this).data('check', '0');
            $(this).find('i').hide();
        });

        if(flag){//若重置前已选择，则标记为未选择
            $(this).data('check', '0');
            $(this).find('i').hide();
        }
        else{//反之，选择
            $(this).data('check', '1');
            $(this).find('i').show();
        }
    });

    $('#submit').click(function () {//提交按钮
        clearInterval(clock);
        ifClock = false;
        var date = new Date(0, 0);
        date.setSeconds(second/10);
        var h = date.getHours(), m = date.getMinutes(), s = date.getSeconds();
        $("#submitModal").modal({backdrop: 'static', keyboard: false});
        var correct_num =0;
        for(var i=0;i<practice_count;i++){
            if(corNum[(i+1).toString()]==true) correct_num++;
        }
        $("#ansResult").text("共 " + practice_count.toString() + " 题，" + "答对 "+ correct_num.toString()
            + " 题" + " 用时 " + two_char(h) + ":" + two_char(m) + ":" + two_char(s));
    });
});
