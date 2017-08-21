$(document).on('turbolinks:load', function(){
  var FIREFOX = /Firefox/i.test(navigator.userAgent);
  if (FIREFOX) {
    $('body').addClass('gecko');
  }
});
