function select2() {
  $('.select2').select2({
    theme: 'bootstrap'
  });
}

function select2Tags() {
  $('.select2_tags').select2({
    tags: true,
    theme: 'bootstrap'
  });
}

$(select2);
$(select2Tags);
