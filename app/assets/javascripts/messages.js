$(document).on('turbolinks:load', function () {
   if ($('.scheduled').is(":checked")) {
      $('.scheduled_time').show();
   }
   else {
      $('.scheduled_time').hide();
   }
})
