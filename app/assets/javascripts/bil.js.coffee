# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
   
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
      tooltip = '<div class="tooltipevent" style="width:auto;height:auto;background:#eb7125;position:absolute;z-index:10001;padding:10px;paddin-top:0px;border:2px solid;">' + calEvent.title+ '<br>' + calEvent.start.format('LLL') + '<br>till<br>'+ calEvent.end.format('LLL') + '</div>'
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

