!function () {
  function bindShortlink(form) {
    var form = $(form)
      , linkField = form.find('.shortlink-field')
      , notice = form.find('.shortlink-notice')

    linkField.change(function () {
      checkLink(linkField.val(), notice)
    })
  }

  function checkLink(link, elem) {
    $.ajax('/short_links/check',
      { data: { link: link }
      , complete: function (xhr) {
          if (xhr.status == 204) elem.show()
          else elem.hide()
        }
      })
  }

  $(function () {
    $('.shortlink-check').each(function (_, elem) { 
      bindShortlink(elem)
    })
  })
}()
