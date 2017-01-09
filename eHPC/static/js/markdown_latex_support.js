document.write('<script type="text/javascript" src="https://cdn.bootcss.com/mathjax/2.7.0/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>');
function latex_support(plainText) {
    var temp = plainText.match(/\\\([\s\S]*?\\\)|\\\[[\s\S]*?\\\]/g);
    if(temp!=null){
        for(var i=0;i<temp.length;i++){
            $("#latex-render-area").append("<span id='sp-rep-latex-" + (i+1).toString() + "'>" + temp[i] + "</span>");
        }
        MathJax.Hub.Queue(["Typeset", MathJax.Hub, 'latex-render-area']);
        var count = 0;
        plainText = plainText.replace(/\\\([\s\S]*?\\\)|\\\[[\s\S]*?\\\]/g, function (word) {
            count++;
            return "sp-rep-latex-" + count.toString();
        });
        plainText = SimpleMDE.prototype.markdown(plainText);

        count = 0;
        plainText = plainText.replace(/sp-rep-latex-\d*/g, function (word) {
            count++;
            return $("#sp-rep-latex-" + count.toString()).html();
        });
        $("#latex-render-area").empty();
        MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
    }
    else{
        plainText = SimpleMDE.prototype.markdown(plainText);
    }
    return plainText;
}

$(function () {
    $(".lab-content-wrap, .content-wrap").append("<div id='latex-render-area' style='display: none'></div>");
});



