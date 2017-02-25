function meetingCalendar() {
  $('#lokalbokning').html('');
  return $('#lokalbokning').fullCalendar({
    eventSources: [
      {
        url: '/lokalbokning',
        data: {
          room: $('#lokalbokning').data('room')
        }
      }
    ],
    weekNumbers: true,
    defaultView: meetingView(),
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,listWeek'
    },
    aspectRatio: meetingHeight(),
    weekNumberTitle: 'V ',
    allDaySlot: false,
    width: 'auto',
    scrollTime: '08:00:00',
    eventMouseover: function(calEvent, jsEvent) {
      var tooltip;
      tooltip = '<div class="tooltipevent" style="width:auto;height:auto;background:#eb7125;position:absolute;z-index:10001;padding:10px;paddin-top:0px;border:2px solid;">' + calEvent.title + '<br>' + calEvent.start.format('LLL') + '<br>till<br>' + calEvent.end.format('LLL') + '</div>';
      $('body').append(tooltip);
      return $(this).mouseover(function() {
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
}

function meetingHeight() {
  if ($(window).width() < 768) {
    return 0.8;
  }
  return 1.2;
}

function meetingView() {
  if ($(window).width() < 768) {
    return 'listWeek';
  }
  return 'agendaWeek';
}

$(document).on('turbolinks:load', meetingCalendar);
