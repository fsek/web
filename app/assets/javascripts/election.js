$('.collapsing').on('shown.bs.collapse', function() {
  return $('html,body').animate({
    scrollTop: $('#views').offset().top
  }, 'slow');
});
