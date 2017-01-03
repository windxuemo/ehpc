$(document).ready(function () {
    var obj = null;
    $("#tb").find("a[name=del-btn]").click(function () {
        obj = this;
        $("#del-warning").modal("show");
    });

    $("#del-confirm").click(function () {
        $.ajax({
            type: "post",
            url: address,
            data: {
                op: 'del',
                id: $(obj).parent().parent().data('id')
            },
            success: function (data) {
                if(data["status"] == "success") {
                    $(obj).parent().parent().remove();
                    $("#del-warning").modal("hide");
                }
                else {
                    alert("删除失败");
                }
            }
        });
    });

});