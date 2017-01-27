function cafeCalendar() {
  $('#cafe-calendar').html(''); // Turbolinks 5 fix
  return $('#cafe-calendar').fullCalendar({
    events: '/hilbertcafe/feed',
    weekNumbers: true,
    minTime: '08:00:00',
    maxTime: '15:00:00',
    defaultView: 'agendaWeek',
    height: 'auto',
    weekends: false,
    header: {
      left: 'prev,next today',
      center: 'title'
    },
    aspectRatio: 1.3,
    weekNumberTitle: 'V ',
    allDaySlot: false,
    slotEventOverlap: false,
    eventMouseover: function(calEvent, jsEvent) {
      var style, tooltip;
      style = 'width:auto;height:auto;background:#eb7125;';
      style = style + 'position:absolute;z-index:10001;padding:10px;';
      tooltip = '<div class="tooltipevent" style="' + style + '">';
      tooltip = tooltip + calEvent.title;
      tooltip = tooltip + '<br>' + calEvent.start.format('LLL');
      tooltip = tooltip + '<br>till<br>' + calEvent.end.format('LLL') + '</div>';
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

$(document).on('turbolinks:load', cafeCalendar);
