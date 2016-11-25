
var spinner = new Spinner({
    lines: 13, // 花瓣数目
    length: 20, // 花瓣长度
    width: 10, // 花瓣宽度
    radius: 30, // 花瓣距中心半径
    corners: 1, // 花瓣圆滑度 (0-1)
    rotate: 0, // 花瓣旋转角度
    direction: 1, // 花瓣旋转方向 1: 顺时针, -1: 逆时针
    color: '#46C37B', // 花瓣颜色
    speed: 1, // 花瓣旋转速度
    trail: 60, // 花瓣旋转时的拖影(百分比)
    shadow: false, // 花瓣是否显示阴影
    hwaccel: false, //spinner 是否启用硬件加速及高速旋转
    className: 'spinner', // spinner css 样式名称
    zIndex: 2e9, // spinner的z轴 (默认是2000000000)
    top: '100px', // spinner 相对父容器Top定位 单位 px
    left: '150px'// spinner 相对父容器Left定位 单位 px
});

$(function () {
    var essay;
    if(question_type == 0){//单选
        $('ul[data-id=choice-options]').find('li').click(function () {
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
            else{//否则更新为：选中
                $(this).data('check', '1');
                $(this).find('i').show();
            }
        });
    }
    else if (question_type == 1 || question_type == 2){//多选、不定项
        $('ul[data-id=choice-options]').find('li').click(function () {
            if($(this).data('check') == '0'){
                $(this).data('check','1');
                $(this).find('i').show();
            }
            else{
                $(this).data('check','0');
                $(this).find('i').hide();
            }
        });
    }
    else if (question_type == 3){//填空
        $('.fill-input').each(function () {
            $(this).css('background','#F4F7F9');
        });
    }
    else if (question_type == 4){//判断
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
    }
    else if (question_type == 5){
        essay = new SimpleMDE({
            element: $('textarea[data-id=target-editor]')[0],
            autosave: true,
            showIcons: ["code", "table"],
            tabSize: 4,
            spellChecker: false
        });
    }

    $('button[data-id=confirm]').click(function () {
        var user_sol = null;
        if(question_type == 0 || question_type == 1 || question_type == 2){
            user_sol = [];
            $('ul[data-id=choice-options]').find('li').each(function () {
                if($(this).data('check') == '1'){
                    user_sol.push($(this).find('span[data-id=option]').eq(0).text());
                }
            });
            if(user_sol.length == 0){
                alert('请至少选择一项');
                return;
            }
            user_sol = user_sol.join(';');
        }
        else if (question_type == 3){
            user_sol = {};
            user_sol['len'] = $('.fill-input').length;
            var count = 0;
            $('.fill-input').each(function () {
                user_sol[count.toString()] = $(this).val();
                count++;
            });
            user_sol = JSON.stringify(user_sol);
        }
        else if (question_type == 4){
            $('ul[data-id=judge-options]').find('li').each(function () {
                if($(this).data('check')=='1'){
                    var temp = $(this).find('span[data-id=option]').eq(0).text();
                    if(temp == 'T') user_sol = 1;
                    else if (temp == 'F') user_sol = 0;
                }
            });
            if(user_sol == null){
                alert('请至少选择一项');
                return;
            }
        }
        else if (question_type == 5){
            user_sol = essay.value();
        }

        $.ajax({
            url: address,
            type: "post",
            data: {
                user_sol: user_sol,
                question_type: question_type,
                question_id: $('div[data-name=question]').eq(0).data('id')
            },
            beforeSend: function () {
                var target = $('#loadingModal').find('.modal-body')[0];
                spinner.spin(target);
                $('#loadingModal').modal({backdrop: 'static', keyboard: false});
            },
            success: function (data) {
                if(data['status'] == 'success'){
                    spinner.spin();
                    $('#fail').hide();
                    $('#pass').fadeIn('normal');
                    setTimeout(function () {
                        window.location.href = address;
                    }, 2000);
                }
                else if (data['status'] == 'fail'){
                    spinner.spin();
                    $('#pass').hide();
                    $('#fail').fadeIn('normal');
                    setTimeout(function () {
                        $('#loadingModal').modal('hide');
                    }, 2000);
                }
            }
        });
    });
});