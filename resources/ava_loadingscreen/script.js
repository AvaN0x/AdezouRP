// https://css-tricks.com/snippets/jquery/shuffle-children/
$.fn.shuffleChildren = function () {
    $.each(this.get(), function (index, el) {
        var $el = $(el);
        var $find = $el.children();

        $find.sort(function () {
            return 0.5 - Math.random();
        });

        $el.empty();
        $find.appendTo($el);
    });
};


$(document).ready(function () {
    $('#slideshow').shuffleChildren();

    var mousePos = {};

    function getRandomInt(min, max) {
        return Math.round(Math.random() * (max - min + 1)) + min;
    }

    $(window).mousemove(function (e) {
        mousePos.x = e.pageX;
        mousePos.y = e.pageY;
    });

    $(window).mouseleave(function (e) {
        mousePos.x = -1;
        mousePos.y = -1;
    });

    var draw = setInterval(function () {
        if (mousePos.x > 0 && mousePos.y > 0) {

            var range = 15;

            var color = "background: #000000;box-shadow: 0 0 5px #ffffff;"

            var sizeInt = getRandomInt(10, 30);
            size = "height: " + sizeInt + "px; width: " + sizeInt + "px;";

            var left = "left: " + getRandomInt(mousePos.x - range - sizeInt, mousePos.x + range) + "px;";

            var top = "top: " + getRandomInt(mousePos.y - range - sizeInt, mousePos.y + range) + "px;";

            var style = left + top + color + size;
            $("<div class='ball' style='" + style + "'></div>").appendTo('body').one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend", function () {
                $(this).remove();
            });
        }
    }, 1);
});

setInterval(function () {
    $('#slideshow > img:first')
        .css('z-index', '5');
    $('#slideshow > img:eq(1)')
        .css('display', 'block');
    $('#slideshow > img:first')
        .fadeOut(500)
        .css('left', '-100%');
    window.setTimeout(function () {
        $('#slideshow > img:first')
            .css('left', '')
            .css('z-index', '')
            .css('display', '')
            .appendTo('#slideshow');
    }, 1000);
}, 3000);

