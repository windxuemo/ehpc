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
        $(this).parent().parent().parent().addClass('open');
        $('#accordion').find('a').removeClass('active');
        $(this).addClass('active');

        var type = $(this).data('type');
        if (type == 'case-description'){
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
                        $('#files-name').hide();
                    }
                }
            });
        }
        else if (type == 'code'){
            $.ajax({
                type: "post",
                url: post_to,
                data: {
                    type: type,
                    case_id: $(obj).parent().parent().parent().data('case_id'),
                    version_id: $(obj).parent().data('version_id')
                },
                success: function (data) {
                    if(data['status'] == 'success'){
                        $('#files-name').children().remove();
                        $('#files-name').unbind('change');

                        var files_name = [];
                        for(var k in data['codes']){
                            files_name.push(k);
                        }
                        files_name.sort(function (a, b) {
                            return a.toLowerCase()>b.toLowerCase();
                        });
                        for(var i=0;i<files_name.length;i++){
                            $("<option value=" + files_name[i] + ">" + files_name[i] + "</option>").appendTo($('#files-name'));
                        }
                        $('#files-name').val(files_name[0]);
                        $('#files-name').show();

                        $('#files-name').change(function () {
                            var selected = $('#files-name').find('option:selected').text();
                            var file_type = selected.substring(selected.lastIndexOf('.')+1, selected.length);
                            if(file_type.toLowerCase() == 'py'){
                                editor.getSession().setMode("ace/mode/python");
                            }
                            else if(file_type.toLowerCase() == 'c' || file_type.toLowerCase() == 'cpp'){
                                editor.getSession().setMode("ace/mode/c_cpp");
                            }
                            editor.setValue(data['codes'][selected]);
                            editor.gotoLine(1);
                        });
                        $('#files-name').trigger('change');
                        $('#case-text').hide();
                        $('#editor').show();
                    }
                }
            });
        }

    });
    $('#accordion').find('a').eq(0).trigger('click');
});