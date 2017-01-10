$(document).ready(function () {
    $('div[data-id=solution]').each(function () {
        var sol = $(this).data('solution');
        var temp = [];
        for(var i=0;i<sol['len'];i++){

            temp.push(sol[i.toString()]);
        }
        temp = temp.join(';');
        $(this).text("参考答案： " + temp);
    });

//根据填空题答案长度生成对应长度的填空框
    $("span[data-id=fill-id]").each(function () {
        var solution_len = $(this).data('len').split(';');
        var i = 0;
        $(".fill-input").each(function () {
            $(this).css('width', ((solution_len[i].length) * 100 + 40).toString() + 'px');
            i++;
        });
    });

    //确认按钮
    $('a[data-id=confirm]').click(function () {
        var your_solution = [];//用户该题的回答

        var flag = false;
        $(this).parent().parent().find('.fill-input').each(function () {
            if($(this).val()==""){
                flag = true;
                return false;
            }
            your_solution.push($(this).val());
        });

        if(flag){
            alert("请填写所有空");
            return;
        }

        if(!ifHasDone[number.toString()]) {//若该题未做过，则标记为已做
            hasDone++;//已完成题目数
            ifHasDone[number.toString()]=true;
        }

        var correct_solution = $($(this).parent().parent().find('div[data-id=solution]')[0]).data('solution');

        var flag = true;
        for(var i=0;i<your_solution.length;i++){
            if(your_solution[i]!=correct_solution[i.toString()]){
                flag = false;
                break;
            }
        }

        if(flag){//比较正确答案
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
