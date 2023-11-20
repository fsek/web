function ready_extra() {
  $('.extra-timer').countdown($('.extra-timer').data('time'), function(event) {
    $(this).html(event.strftime($('.extra-timer').data('format')))
  });
};

$(document).on('turbolinks:load', ready_extra);
