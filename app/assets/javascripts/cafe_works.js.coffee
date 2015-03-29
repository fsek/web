jQuery ->
  $('.datetimepicker').datetimepicker locale: 'sv', format: 'DD/MM/YYYY HH:mm'
jQuery ->
  $('#date').datepicker()
jQuery ->
  $('#date2').datepicker()
loadCalendar = ->
  $('#hilbertkalender').fullCalendar
    events: '/hilbertcafe',
    weekNumbers: true,
    minTime: "08:00:00",
    maxTime: "13:00:00",
    defaultView: 'agendaWeek',
    height: "auto",
    weekends: false,
    header: {
      left: 'prev,next today',
      center: 'title',
    },
    aspectRatio: 1.3,
    weekNumberTitle: "V ",
    allDaySlot: false,
    slotEventOverlap: false,
    eventMouseover: (calEvent, jsEvent) ->
      style = 'width:auto;height:auto;background:#eb7125;'
      style = style + 'position:absolute;z-index:10001;padding:10px;'
      tooltip = '<div class="tooltipevent" style="' + style + '">'
      tooltip = tooltip + calEvent.title
      tooltip = tooltip + '<br>' + calEvent.start.format('LLL')
      tooltip = tooltip + '<br>till<br>' + calEvent.end.format('LLL') + '</div>'
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
$(document).ready(loadCalendar)
