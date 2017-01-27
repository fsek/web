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

// Turbolinks 5 fix
function clearSelect2() {
  $('.select2').select2('destroy');
  $('.select2_tags').select2('destroy');
}

$(document).on('turbolinks:load', select2);
$(document).on('turbolinks:load', select2Tags);
$(document).on('turbolinks:before-cache', clearSelect2)
