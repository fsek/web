function carCalendar() {
  $('#bilkalender').html(''); // Turbolinks 5 fix
  return $('#bilkalender').fullCalendar({
    events: '/bilbokning',
    weekNumbers: true,
    defaultView: 'agendaWeek',
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    aspectRatio: 1.3,
    weekNumberTitle: "V ",
    allDaySlot: false,
    width: "auto",
    eventMouseover: function(calEvent, jsEvent) {
      var tooltip;
      tooltip = '<div class="tooltipevent" style="width:auto;height:auto;background:#eb7125;position:absolute;z-index:10001;padding:10px;paddin-top:0px;border:2px solid;">' + calEvent.title + '<br>' + calEvent.start.format('LLL') + '<br>till<br>' + calEvent.end.format('LLL') + '</div>';
      $('body').append(tooltip);
      return $(this).mouseover(function(e) {
        $(this).css('z-index', 10000);
        $('.tooltipevent').fadeIn('500');
        return $('.tooltipevent').fadeTo('10', 1.9);
      }).mousemove(function(e) {
        $('.tooltipevent').css('top', e.pageY + 10);
        return $('.tooltipevent').css('left', e.pageX + 20);
      });
    },
    eventMouseout: function(calEvent, jsEvent) {
      $(this).css('z-index', 8);
      return $('.tooltipevent').remove();
    }
  });
};

$(document).on('turbolinks:load', carCalendar);
