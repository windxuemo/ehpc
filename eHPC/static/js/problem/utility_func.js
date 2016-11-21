
//答题进度条
function setBarWidth(doneNumber) {
    $(".progress-bar").css("width",(doneNumber/practice_count*100).toString() + "%");//更改答题进度条
    $(".has-done").text(" " + doneNumber.toString());//更改答题数
}

//答题计时器
function two_char(n) {//标准化时间格式
    return n >= 10 ? n : "0" + n;
}

var clock = 0,second = 0, ifClock=false, hasDone=0;
function updateClock(sec) {//更新时间
    sec++;
    var date = new Date(0, 0);
    date.setSeconds(sec/10);
    var h = date.getHours(), m = date.getMinutes(), s = date.getSeconds();
    $("#clock").text(two_char(h) + ":" + two_char(m) + ":" + two_char(s));
    second = sec;
}

window.onload = function(){//页面加载完毕时启动计时
    clock = setInterval("updateClock(second)", 100);
    ifClock = true;
};