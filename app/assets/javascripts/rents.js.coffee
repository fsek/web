jQuery ->
  $('.datetimepicker1').datetimepicker
    format: 'DD/MM/YYYY HH:mm'
  $('.datetimepicker2').datetimepicker
    format: 'DD/MM/YYYY HH:mm'
loadCalendar = ->
  $('#bilkalender').fullCalendar
    events: '/bil',
    weekNumbers: true,
    defaultView: 'agendaWeek'
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    aspectRatio: 1.3,
    weekNumberTitle: "V ",
    allDaySlot: false,
    width: "auto",
    eventMouseover: (calEvent, jsEvent) ->
      tooltip = '<div class="tooltipevent" style="width:auto;height:auto;background:#eb7125;position:absolute;z-index:10001;padding:10px;paddin-top:0px;border:2px solid;">' + calEvent.title + '<br>' + calEvent.start.format('LLL') + '<br>till<br>' + calEvent.end.format('LLL') + '</div>'
      $('body').append tooltip
      $(this).mouseover((e) ->
        $(this).css 'z-index', 10000
        $('.tooltipevent').fadeIn '500'
        $('.tooltipevent').fadeTo '10', 1.9
      ).mousemove (e) ->
        $('.tooltipevent').css 'top', e.pageY + 10
        $('.tooltipevent').css 'left', e.pageX + 20
    eventMouseout: (calEvent, jsEvent) ->
      $(this).css 'z-index', 8
      $('.tooltipevent').remove()
$('document').ready(loadCalendar)

$('document').ready ->
  $('input[type=\'checkbox\']#rent_disclaimer').on 'change', ->
    if $('#rent_disclaimer').is(':checked')
      $('.after_disclaimer').show()
      $('html, body').animate { scrollTop: $('.after_disclaimer').offset().top }, 1000
    else
      $('.after_disclaimer').hide()
  if $('#rent_disclaimer').is(':checked')
    $('.after_disclaimer').show()
