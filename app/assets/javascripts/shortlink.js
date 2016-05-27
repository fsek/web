!function () {
  function bindShortlink(form) {
    var form = $(form)
      , linkField = form.find('#short_link_link')
      , notice = form.find('.shortlink-notice')

    linkField.change(function () {
      checkLink(linkField.val(), notice)
    })
  }

  function checkLink(link, elem) {
    $.ajax('/snabblankar/check',
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
