$(document).ready(function () {
    $("#tb").find("a[name=del-btn]").each(function () {
        $(this).click(function () {
            var obj = this;
            $.ajax({
                type: "post",
                url: "{{ url_for('admin.process_practice') }}",
                data: {op: 'del', id: $(obj).parent().parent().data('id')},
                success: function (data) {
                    if(data["status"] == "success")
                    {
                        $(obj).parent().parent().remove();
                        alert("删除成功");
                    }
                    else
                    {
                        alert("删除失败");
                    }
                }
            });
        });
    })
});