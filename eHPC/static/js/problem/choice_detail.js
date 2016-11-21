$(document).ready(function () {
    //单选题选项逻辑
    $('div[data-name=choice][data-type="0"]').find('ul[data-id=choice-options]').find('li').click(function () {
        var flag = false;//当前选项是否已被选择
        if($(this).data('check')=='1'){
            flag = true;
        }
        $(this).parent().children().each(function () {//重置所有选项状态为：未选择
            $(this).data('check', '0');
            $(this).find('i').hide();
        });

        //使用户可以取消【单选题】中已选择的一项
        if(flag){//若当前选项在重置前已选择，则更新为：未选择
            $(this).data('check', '0');
            $(this).find('i').hide();
        }
        else {//否则更新为：选中
            $(this).data('check', '1');
            $(this).find('i').show();
        }
    });

    //多选题、不定项选择选项逻辑
    $('div[data-name=choice][data-type!="0"]').find('ul[data-id=choice-options]').find('li').click(function () {
        if($(this).data('check') == '0'){
            $(this).data('check','1');
            $(this).find('i').show();
        }
        else{
            $(this).data('check','0');
            $(this).find('i').hide();
        }
    });

    //确认按钮
    $('a[data-id=confirm]').click(function () {
        var your_solution = [];//用户该题的回答
        $(this).parent().parent().find('.choice-options').each(function () {
            if($(this).data('check')=='1'){
                var temp = $(this).find('span[data-id=option]').eq(0).text();
                your_solution.push(temp);
            }
        });
        if(your_solution.length==0){
            alert("请至少选择一项");
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
            setBarWidth(hasDone);
            $(this).parent().parent().find('img[data-id=choice_wrong]').hide();
            $(this).parent().parent().find('img[data-id=choice_correct]').show();
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
