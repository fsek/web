var bottom;
bottom = function () {
    var $copyright = $('#copyright')
    var $footer = $('#footer')

    var docHeight = $(window).height();
    var copyrightBottom = ($copyright.position().top + $copyright.height());
    var footerPadding = parseInt($footer.css('padding-top')) +
                        parseInt($footer.css('padding-bottom'));

    var diff = docHeight - copyrightBottom + footerPadding;


    if (copyrightBottom < docHeight) {
        $footer.css('margin-top', diff + 'px');
    }
};

$(document).ready(bottom)
