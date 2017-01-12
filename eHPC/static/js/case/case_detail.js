$(function () {
    var Accordion = function (el, multiple) {
        this.el = el || {};
        this.multiple = multiple || false;
        // Variables privadas
        var links = this.el.find('.link');
        // Evento
        links.on('click', {el: this.el, multiple: this.multiple}, this.dropdown)
    };
    Accordion.prototype.dropdown = function (e) {
        var $el = e.data.el;
        $this = $(this);
        $next = $this.next();
        $next.slideToggle();
    };
    var cur_code = "", cur_language = "", cur_state = "view";
    var accordion_html = $('#accordion');
    var accordion = new Accordion(accordion_html, false);

    accordion_html.find('a').click(function () {
        cur_state = "view";
        $("#mode").text("编辑代码");
        var obj = this;
        $('.link').parent().removeClass('open');
        accordion_html.find('a').removeClass('active');
        $(this).addClass('active');
        $('span[data-id=case-name]').css('color', '#616161');
        $('i[data-id=case-icon]').css('color',"#616161").css('-webkit-transform',"initial")
            .css('-ms-transform',"initial").css('-o-transform',"initial").css('transform',"initial");
        $('i[data-id=case-icon2]').css('color',"#616161");


        var type = $(this).data('type');
        if (type == 'case-description'){
            var parent3 = $(this).parent().parent().parent();
            parent3.find('span[data-id=case-name]').css('color',"#46c37b");
            parent3.find('i[data-id=case-icon]').css('color',"#46c37b").css('-webkit-transform',"rotate(180deg)")
                .css('-ms-transform',"rotate(180deg)").css('-o-transform',"rotate(180deg)").css('transform',"rotate(180deg)");
            parent3.find('i[data-id=case-icon2]').css('color',"#46c37b");
            $('span[data-id=title]').text($(this).text());
            $.ajax({
                type: "post",
                url: post_to,
                data: {
                    type: type,
                    case_id: $(obj).parent().parent().parent().data('case_id')
                },
                success: function (data) {
                    if(data['status'] == 'success'){
                        $('#show-description').html(latex_support(data['description']));
                        $('#case-text').show();
                        $('#code-area').hide();
                    }
                }
            });
        }
        else if (type == 'version-description'){
            $(this).parent().parent().parent().addClass('open');
            var parent5 = $(this).parent().parent().parent().parent().parent();
            parent5.find('span[data-id=case-name]').css('color',"#46c37b");
            parent5.find('i[data-id=case-icon]').css('color',"#46c37b").css('-webkit-transform',"rotate(180deg)")
                .css('-ms-transform',"rotate(180deg)").css('-o-transform',"rotate(180deg)").css('transform',"rotate(180deg)");
            parent5.find('i[data-id=case-icon2]').css('color',"#46c37b");
            $('span[data-id=title]').text($(this).text());
            $.ajax({
                type: "post",
                url: post_to,
                data: {
                    type: type,
                    auto_increment: $(obj).parent().parent().parent().data('auto_increment')
                },
                success: function (data) {
                    if(data['status'] == 'success'){
                        $('#show-description').html(latex_support(data['description']));
                        $('#case-text').show();
                        $('#code-area').hide();
                    }
                }
            });
        }
        else if (type == 'code'){
            $(this).parent().parent().parent().addClass('open');
            parent5 = $(this).parent().parent().parent().parent().parent();
            parent5.find('span[data-id=case-name]').css('color',"#46c37b");
            parent5.find('i[data-id=case-icon]').css('color',"#46c37b").css('-webkit-transform',"rotate(180deg)")
                .css('-ms-transform',"rotate(180deg)").css('-o-transform',"rotate(180deg)").css('transform',"rotate(180deg)");
            parent5.find('i[data-id=case-icon2]').css('color',"#46c37b");
            $.ajax({
                type: "post",
                url: post_to,
                data: {
                    type: type,
                    auto_increment: $(obj).parent().parent().parent().data('auto_increment'),
                    file_name: $(obj).text()
                },
                success: function (data) {
                    if(data['status'] == 'success'){
                        var viewer = $('#viewer');
                        $('#case-text').hide();
                        var file_type = $(obj).text().substring($(obj).text().lastIndexOf('.')+1, $(obj).text().length);
                        if(file_type.toLowerCase() == 'py'){
                            viewer.addClass('Python').removeClass('C').removeClass('C++');
                            cur_language = "python";
                        }
                        else if(file_type.toLowerCase() == 'c'){
                            viewer.addClass('C').removeClass('Python').removeClass('C++');
                            cur_language = "C";
                        }
                        else if(file_type.toLowerCase() == 'cpp'){
                            viewer.addClass('C++').removeClass('C').removeClass('Python');
                            cur_language = "C++";
                        }
                        cur_code = data['code'];
                        viewer.text(data['code']);
                        viewer.each(function(i, block) {
                            hljs.highlightBlock(block);
                        });
                        $('#code-area').show();
                        $('#code-viewer').show();
                        $('#code-editor').hide();
                        cur_state = "view";
                        $(this).text("查看代码");
                    }
                    else if (data['status'] == 'fail'){
                        alert('获取文件代码失败，请重试!');
                    }
                }
            });
        }

    });
    accordion_html.find('a').eq(0).trigger('click');
    $("#mode").click(function () {
        if(cur_state == "view"){
            $(this).text("查看代码");
            cur_state = "edit";
            $('#code-viewer').hide();
            $('#code-editor').show();
            if(cur_language == 'C' || cur_language == "C++"){
                editor.getSession().setMode("ace/mode/c_cpp");
            }
            else{
                editor.getSession().setMode("ace/mode/"+cur_language);
            }
            editor.setValue(cur_code);
            $('#editor').css("height", editor.session.getLength()*17);
            editor.navigateFileStart();
        }
        else if(cur_state == 'edit'){
            $(this).text("编辑代码");
            cur_state = "view";
            $('#code-viewer').show();
            $('#code-editor').hide();
        }
    });
});

