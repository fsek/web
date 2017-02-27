function ready() {
  $('.timer').countdown($('.timer').data('time'), function(event) {
    $(this).html(event.strftime($('.timer').data('format')));
  });
};

$(document).on('turbolinks:load', ready);
