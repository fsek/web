function carou2() {
  $('[data-ride="carou"]').each(function () {
    $(this).carousel();
  });
}

$(document).on('turbolinks:load', carou2);
