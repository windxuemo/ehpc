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
    var accordion = new Accordion($('#accordion'), false);

    $('#accordion').find('a').click(function () {
        var obj = this;
        $('.link').parent().removeClass('open');
        $('#accordion').find('a').removeClass('active');
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
                        $('#show-description').text(data['description']);
                        $('#case-text').show();
                        $('#editor').hide();
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
                    case_id: $(obj).parent().parent().parent().parent().parent().data('case_id'),
                    version_id: $(obj).parent().parent().parent().data('version_id')
                },
                success: function (data) {
                    if(data['status'] == 'success'){
                        $('#show-description').text(data['description']);
                        $('#case-text').show();
                        $('#editor').hide();
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
                    case_id: $(obj).parent().parent().parent().parent().parent().data('case_id'),
                    version_id: $(obj).parent().parent().parent().data('version_id'),
                    file_name: $(obj).text()
                },
                success: function (data) {
                    if(data['status'] == 'success'){
                        $('#case-text').hide();
                        var file_type = $(obj).text().substring($(obj).text().lastIndexOf('.')+1, $(obj).text().length);
                        if(file_type.toLowerCase() == 'py'){
                            editor.getSession().setMode("ace/mode/python");
                        }
                        else if(file_type.toLowerCase() == 'c' || file_type.toLowerCase() == 'cpp'){
                            editor.getSession().setMode("ace/mode/c_cpp");
                        }
                        editor.setValue(data['code']);
                        editor.gotoLine(1);
                        $('#editor').show();
                    }
                }
            });
        }

    });
    $('#accordion').find('a').eq(0).trigger('click');
});