// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui/effect.all
//= require bootstrap
//= require_self
//= require jquery-ui/datepicker
//= require moment
//= require moment/sv
//= require fullcalendar
//= require fullcalendar/lang/sv.js
//= require fancybox
//= require wice_grid.js
//= require_tree .
//= require turbolinks
//= require gallery_hook.js
//= require jquery.countdown
//= require bootstrap-datetimepicker
//= require pickers

var bottom;
bottom = function () {
    var docHeight = $(window).height();
    var footerHeight = $('#copyright').height()
    var footerTop = $('#copyright').position().top + footerHeight;

    if (footerTop < docHeight) {
        $('#footer').css('margin-top', 22 + (docHeight - footerTop) + 'px');
    }
};

$(document).ready(bottom)
