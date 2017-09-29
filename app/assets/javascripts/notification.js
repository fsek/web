$(function() {
  var div = document.createElement('div');
  $(div).addClass("extra");
  $(".notification.has_extra").hover(
    function() {showExtra($(this), div)},
    function() {hideExtra(div)}
  );

  $(".notifications-list").on("scroll", function() {
    hideExtra(div);
  });

  $(".notification").not(".seen").on("mouseenter", function() {
    var id = $(this).attr("uid"), notification = $(this);
    notification.addClass("seen");
    $.ajax({
      url: '/anvandare/notifikationer/' + id + '/look',
      type: 'PATCH',
      success: function(resp) {
        if(resp.unread == 0) {
          hideAll();
        } else {
          $(".notifications_count").html(resp.unread);
        }
      },
      error: function(resp) {
        notification.removeClass("seen");
        alert(resp);
      }
    });
  });

  $(".notifications_look_all").on("click", function() {
    if($(".notifications-list").find(".notification").not(".seen").length != 0) {
      $.ajax({
        url: '/anvandare/notifikationer/look_all',
        success: function(resp) {
          hideAll();
          $.each($(".notifications-list").find(".notification").not(".seen"), function() {
            $(this).addClass("seen");
          });
        },
        error: function(resp) {
          alert(resp);
        }
      });
    }
  });

  $(document).on('click', '.notifications-dropdown.dropdown-menu', function (e) {
    e.stopPropagation();
  });
});

function hideAll() {
  $(".notifications_look_all").hide();
  $(".notifications_count").hide();
  $(".has_notifications").removeClass("has_notifications");
}

function showExtra(notif, div) {
  var extra = notif.attr("extra");
  $(div).text(extra)
        .css({"top": notif.offset().top,
              "left": notif.offset().left-200})
        .show()
        .appendTo('body');
}

function hideExtra(div) {
  $(div).hide();
}
