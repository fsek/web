function ready() {
  $('.timer').countdown($('.timer').data('time'), function(event) {
    $(this).html(event.strftime('%D dagar %H:%M:%S'));
  });
};

$(document).on('turbolinks:load', ready);
