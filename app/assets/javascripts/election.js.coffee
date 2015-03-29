$('.collapsing').on 'shown.bs.collapse', ->
  $('html,body').animate {scrollTop: $('#views').offset().top}, 'slow'

jQuery ->
  $('.datetimepicker1').datetimepicker locale: 'sv', format: 'DD/MM/YYYY HH:mm'
  $('.datetimepicker2').datetimepicker locale: 'sv', format: 'DD/MM/YYYY HH:mm'
