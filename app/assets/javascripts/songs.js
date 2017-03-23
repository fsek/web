// Run on load
$(document).on("turbolinks:load", function() {
  // Check if search bar exists
  if($("#songSearch")[0]) {
    // Runs window resize
    $(window).resize(function() {
      // Make sure to not run too often
      setTimeout(function() {
        adjSearch();
        adjPlaceholder();
      }, 500);
    });

    adjPlaceholder();
    adjShadow();
    // Handle click events and redirect to song
    $("tr[data-link]").click(function() {
      Turbolinks.visit($(this).data("link"));
    });

    // Update list when searching
    $("#songSearch").on("keyup", adjSearch());
  }
});

// Adds shadow to song list to clarify scrollability
function adjShadow() {
  if($(".song-table-round").height() > 500) {
    $(".song-grid").addClass("scroll-shadow")
  } else if($(".song-grid").hasClass("scroll-shadow")) {
    $(".song-grid").removeClass("scroll-shadow")
  }
}

// Adds different search bar placeholders depending on screen size (device)
function adjPlaceholder() {
  if($(window).width() < 992) {
    $("#songSearch").attr("placeholder", "Skriv * för alla låtar")
  } else {
    $("#songSearch").attr("placeholder", "Sök efter en låt")
  }
}

// Hides and shows songs in the list based on search input
function adjSearch() {
  var search = $("#songSearch").val().toLowerCase();

  // Hides the entire list if low screen width and search bar is empty
  if(search == "" && $(window).width() < 992 ) {
    $(".song-grid table").hide();
  } else if($(".song-grid table").is(":hidden")){
    $(".song-grid table").show();
  }

  // Allows showing of whole song list on small screens
  if(search == "*") {
    $(".song-grid table").show();
  } else {
    // Shows matching songs
    $(".song-row").each(function() {
      if($(this).text().toLowerCase().indexOf(search) < 0) {
        $(this).hide();
      } else {
        $(this).show();
      }
    });
  }

  // List size will change when searching, why it is required to run this
  adjShadow();
}
