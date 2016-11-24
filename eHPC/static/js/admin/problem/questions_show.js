$(document).ready(function () {
    $("#tb").find("a[name=del-btn]").click(function () {
        var obj = this;
        $.ajax({
            type: "post",
            url: address,
            data: {op: 'del', id: $(obj).parent().parent().data('id')},
            success: function (data) {
                if(data["status"] == "success") {
                    $(obj).parent().parent().remove();
                    alert("删除成功");
                }
                else {
                    alert("删除失败");
                }
            }
        });
    });
});