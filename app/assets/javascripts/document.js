function placeholder() {
  $('#grid_f_title').attr('placeholder', 'Filter');
};

$(document).on('turbolinks:load', placeholder);
