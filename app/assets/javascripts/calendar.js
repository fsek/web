function eventCalendar() {
  $('#event_calendar').html('');  // Turbolinks 5 fix
  return $('#event_calendar').fullCalendar({
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,listWeek'
    },
    defaultView: calendarView(),
    eventSources: [
      {
        url: '/kalender',
        color: 'orange'
      }
    ],
    aspectRatio: calendarHeight(),
    axisFormat: 'HH:mm',
    timeFormat: 'HH:mm',
    allDay: false,
    allDayText: 'Heldag',
    firstDay: 1,
    weekNumbers: true,
    scrollTime: '08:00:00',
    monthNames: ['Januari', 'Februari', 'Mars', 'April', 'Maj', 'Juni', 'Juli', 'Augusti', 'September', 'Oktober', 'November', 'December'],
    dayNames: ['Söndag', 'Måndag', 'Tisdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lördag'],
    dayNamesShort: ['Sön', 'Mån', 'Tis', 'Ons', 'Tors', 'Fre', 'Lör'],
    weekNumberTitle: 'V'
  });
};

function english() {
  $('#event_calendar_en').html('');
  return $('#event_calendar_en').fullCalendar({
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,listWeek'
    },
    defaultView: calendarView(),
    eventSources: [
      {
        url: '/en/kalender',
        color: 'orange'
      }
    ],
    aspectRatio: 2,
    axisFormat: 'HH:mm',
    timeFormat: 'HH:mm',
    allDay: false,
    allDayText: 'Heldag',
    firstDay: 1,
    weekNumbers: true,
    scrollTime: '08:00:00',
    monthNames: ['January', 'Februay', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    weekNumberTitle: 'W'
  });
};

function calendarView() {
  if ($(window).width() < 768) {
    return 'listWeek';
  }
  else if ($(window).width() < 992) {
    return 'agendaWeek';
  }
  return 'month';
}

function calendarHeight() {
  if ($(window).width() < 576) {
    return 0.8;
  }
  else if ($(window).width() < 768) {
    return 1;
  }
  else if ($(window).width() < 992) {
    return 1.2;
  }
  return 2;
}

function calendarResize() {
  $(window).resize(function() {
    $('#event_calendar').fullCalendar('option', 'aspectRatio', calendarHeight());
  });
}


$(document).on('turbolinks:load', eventCalendar);
$(document).on('turbolinks:load', english);
$(document).on('turbolinks:load', calendarResize);
