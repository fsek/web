var ready;
ready = function() {
  $(".timer").countdown($(".timer").data("time"), function(event) {
    $(this).html(event.strftime("%D dagar %H:%M:%S"));
  });
};

$(document).ready(ready);
$(document).on("page:load", ready);

