$(document).on('turbolinks:load', function() {
  var div = document.createElement('div');
  $(div).addClass('extra');
  $('.notification.has-extra').hover(
    function() {showExtra($(this), div)},
    function() {hideExtra(div)}
  );

  $('.notifications-list').on('scroll', function() {
    hideExtra(div);
  });

  $('.notification-toggle').on('click', function() {
    $.ajax({
      url: '/anvandare/notifikationer/look_all',
      type: 'GET',
      success: function() {
          hideAll();
      }
    });
  });

  $('.notification').on('click', function() {
    var id = $(this).attr('uid')
    $.ajax({
      url: '/anvandare/notifikationer/' + id + '/visit',
      type: 'PATCH',
      success: function() {
        hideAll();
        TurboLinks.visit($(this).attr('href'))
      }
    });
  });
});

function hideAll() {
  $('.notifications-count').hide();
  $('.has-notifications').removeClass('has-notifications');
}

function showExtra(notif, div) {
  var extra = notif.attr('extra');
  $(div).text(extra)
        .css({'top': notif.offset().top,
              'left': notif.offset().left-200})
        .show()
        .appendTo('body');
}

function hideExtra(div) {
  $(div).hide();
}
