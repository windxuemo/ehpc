
var number=1;//当前答题题号
var corNum = {} ,ifHasDone = {};//题目是否回答正确，题目是否已答
for (var i=0;i<practice_count;i++)
{
    corNum[(i+1).toString()] = false;
    ifHasDone[(i+1).toString()] =false;
}

//下一题按钮点击事件
$('#nextProblem').click(function () {
    if(number==practice_count) return;//若当前题目已是最后一题，则退出函数
    number++;//切换下一题
    $('#lastProblem').removeClass('disabled');//上一题按钮设置为可点
    $('div[data-id=' + (number-1).toString() + ']').hide();
    $('div[data-id=' + number.toString() + ']').show();
    if(number==practice_count) $(this).addClass("disabled");//若已是最后一题，则自身标记为不可点
});

//上一题按钮点击事件
$('#lastProblem').click(function () {
    if(number==1) return;
    number--;
    $('#nextProblem').removeClass('disabled');
    $('div[data-id=' + (number+1).toString() + ']').hide();
    $('div[data-id=' + number.toString() + ']').show();
    if(number==1) $(this).addClass("disabled");
});

//显示答案
$('#show-solution').click(function () {
    $('div[data-id=' + number.toString() + ']').find('div[data-id=solution]').toggle();
});

$('#pause').click(function () {//暂停按钮
    clearInterval(clock);//停止更新时间
    ifClock = false;
    $("#pauseModal").modal({backdrop: 'static', keyboard: false});//显示暂停模态框
});

$('#continue').click(function () {//继续按钮
    if(ifClock==false)
    {
        $("#pauseModal").modal("hide");//隐藏暂停模态框
        clock = setInterval("updateClock(second)", 100);//继续计时
        ifClock = true;
    }
});

$('#confirm-submit').click(function () {
    window.location.href=address;
});

$('#cancel-submit').click(function () {
    if(ifClock == false){
        clock = setInterval("updateClock(second)", 100);
        ifClock = true;
    }
    $("#submitModal").modal('hide');
});

$('#question-index').find('a').click(function () {
    var temp = $(this).data('id');
    $('div[data-id=' + number.toString() + '][class=panel]').hide();
    number = Number(temp);
    $('div[data-id=' + number.toString() + '][class=panel]').show();
});