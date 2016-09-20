$("li.nav-hover")
    .mouseenter(function (event) {
        $(this).addClass("open");
    })
    .mouseleave(function (event) {
        $(this).removeClass("open");
    });


var placeholder = $("input.js-search").prop('placeholder')
$("input.js-search")
    .focus(function () {
        $(this).prop("placeholder", "").addClass("active");
    })
    .blur(function () {
        $(this).prop("placeholder", placeholder).removeClass("active");
    });
