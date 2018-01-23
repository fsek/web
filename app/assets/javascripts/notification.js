$(document).on('turbolinks:load', function() {
  var div = document.createElement("div");
  $(div).addClass("extra");
  $(".notification.has-extra").hover(
    function() {showExtra($(this), div)},
    function() {hideExtra(div)}
  );

  $(".notifications-list").on("scroll", function() {
    hideExtra(div);
  });

  $(".notification:not(.seen)").on("mouseenter", function() {
    var id = $(this).attr("uid"), notification = $(this);
    notification.addClass("seen");
    $.ajax({
      url: "/anvandare/notifikationer/" + id + "/look",
      type: "PATCH",
      success: function(resp) {
        if(resp.unread === 0) {
          hideAll();
        } else {
          $(".notifications-count").html(resp.unread);
        }
      },
      error: function(resp) {
        notification.removeClass("seen");
        console.log(resp);
      }
    });
  });

  $(".notifications-look-all").on("click", function() {
    if($(".notifications-list").find(".notification").not(".seen").length !== 0) {
      $.ajax({
        url: "/anvandare/notifikationer/look_all",
        success: function() {
          hideAll();
          $.each($(".notifications-list").find(".notification").not(".seen"), function() {
            $(this).addClass("seen");
          });
        },
        error: function(resp) {
          console.log(resp);
        }
      });
    }
  });
});

function hideAll() {
  $(".notifications-look-all").hide();
  $(".notifications-count").hide();
  $(".has-notifications").removeClass("has-notifications");
}

function showExtra(notif, div) {
  console.log("extra");
  var extra = notif.attr("extra");
  $(div).text(extra)
        .css({"top": notif.offset().top,
              "left": notif.offset().left-200})
        .show()
        .appendTo("body");
}

function hideExtra(div) {
  $(div).hide();
}
