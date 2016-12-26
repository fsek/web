function select2() {
  $('.select2').select2({
    theme: 'bootstrap',
    width: '100%'
  });
}

function select2Tags() {
  $('.select2_tags').select2({
    tags: true,
    theme: 'bootstrap',
    width: '100%'
  });
}

$(document).on('turbolinks:load', select2);
$(document).on('turbolinks:load', select2Tags);
