var eventCalendar;

eventCalendar = function() {
  return $('#event_calendar').fullCalendar({
    header: {
      left: 'today',
      center: 'prev    title    next',
      right: 'month,agendaWeek'
    },
    defaultView: 'month',
    eventSources: [
      {
        url: '/kalender',
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
    monthNames: ['Januari', 'Februari', 'Mars', 'April', 'Maj', 'Juni', 'Juli', 'Augusti', 'September', 'Oktober', 'November', 'December'],
    dayNames: ['Söndag', 'Måndag', 'Tisdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lördag'],
    dayNamesShort: ['Sön', 'Mån', 'Tis', 'Ons', 'Tors', 'Fre', 'Lör'],
    weekNumberTitle: 'V'
  });
};

english = function() {
  return $('#event_calendar_en').fullCalendar({
    header: {
      left: 'today',
      center: 'prev    title    next',
      right: 'month,agendaWeek'
    },
    defaultView: 'month',
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
    monthNames: ['January', 'Februay', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    weekNumberTitle: 'W'
  });
};

$(document).ready(eventCalendar);
$(document).ready(english);
