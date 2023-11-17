function ready() {
  $('.extra_timer').countdown($('.extra_timer').data('time'), function(event) {
    $(this).html(event.strftime($('.extra_timer').data('format')));
  });
};

$(document).on('turbolinks:load', ready);
