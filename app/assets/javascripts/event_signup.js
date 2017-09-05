function customGroupFocus() {
  $('.group-radio:last').prop('checked', true);
}

$(document).on('turbolinks:load', function() {
  $('.group-custom').on('focus', customGroupFocus);
});
