$(document).on('turbolinks:load', function() {
  // Ensures code only runs on pages containing event errors
  var ee = $('.event-errors')
  if(ee !== null) {
    var tabs = $('.new_event, .edit_event').find('.tab-pane');

    tabs.each(function() {
      // Finds the sidemenu-link corresponding to the 
      // tab containing the error and add error class
      if($(this).find('.form-group').hasClass('has-error')) {
        ee.find('a[href="#' + $(this)
        .attr('id')+'"]')
        .parent('.list-group-item')
        .addClass('event-error')
      }
    })
  }
})
