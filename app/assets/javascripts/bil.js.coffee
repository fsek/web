# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
   
loadCalendar = ->    
  $('#bilkalender').fullCalendar
    events: '/bil/bokningar',
    weekNumbers: true,    
    defaultView: 'agendaWeek'
    header: {
        left: 'prev,next today',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
    },
    aspectRatio: 1.3,
    weekNumberTitle: "V ",
    allDaySlot: false            
$(document).ready(loadCalendar)