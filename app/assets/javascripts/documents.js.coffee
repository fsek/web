initDatepickers = ->
  $('.date_field').datepicker
    dateFormat: 'dd-mm-yy',
    prevText: '<i class="icon-chevron-left"></i>',
    nextText: '<i class="icon-chevron-right"></i>'

$(document).ready(initDatepickers)
