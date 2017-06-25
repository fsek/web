!function() {
  function parse_emails(text) {
    return text.split(/\s+/).filter(function(s) { return s !== '' })
  }

  function update_table(aliases) {
    var tbody = $('#alias-tbody')

    tbody.html('')

    aliases.forEach(function(a) {
      tbody.append(create_row(a))
    })

    bind_edit_rows()
    set_status('')
  }

  function create_row(a) {
    var ul = $('<ul>')
    a.targets.forEach(function(t) {
      ul.append($('<li>'+t+'</li>'))
    })

    var tr = $('<tr>')
    tr.data({ username: a.username
            , domain: a.domain
            , targets: a.targets
            }
    )

    tr.append($('<td class=alias-key>'+a.username+'@'+a.domain+'</td>'))
    tr.append($('<td class=alias-arrow>&#x2192;</td>'))
    tr.append($('<td class=alias-targets>').append(ul))
    tr.append($('<td class=alias-control><a class=alias-edit-button href=#>'+
                '<i class="fa fa-2x fa-edit"></i></a></td>'))
    return tr
  }

  function set_status(html) {
    $('#alias-status').html(html)
  }

  function handle_error(row, xhr) {
    var div = $('<div class="alert alert-danger">')
              .append('Fel, sparades inte! Skriv vettiga emails på varsin rad. '
                     +'Du får bara skapa alias under domäner som F faktiskt äger. '
                     +'Om du vill göra ett alias som pekar på ett annat alias, '
                     +'så måste du skriva ut "@fsektionen.se". Försök nu igen.')

    row.find('.alias-targets').append(div)
  }

  function handle_create_new(username, domain) {
    var new_alias = { username: username, domain: domain, targets: [] }

    update_table([ new_alias ])
    handle_edit_row($('#alias-tbody tr'))
    set_status('Aliaset finns inte, men du kan skapa det om du vill.')
  }

  function handle_save_row_complete(row, data) {
    var aliases = data.mail_aliases

    if (aliases.length === 0) {
      row.replaceWith('')
    } else {
      row.replaceWith(create_row(data.mail_aliases[0]))
    }
    bind_edit_rows()
    set_status('')
  }

  function handle_save_row(row) {
    $.ajax('/admin/mail_aliases/update',
           { method: 'PUT'
           , data: { mail_alias: { username: row.data('username')
                                 , domain: row.data('domain')
                                 , targets: parse_emails(row.find('.alias-target-area').val())
                                 } }
           , error: function(xhr) { handle_error(row, xhr) }
           , success: function(data) { handle_save_row_complete(row, data) }
           }
    )
  }

  function handle_edit_row(row) {
    var targets_td = row.find('.alias-targets')
      , control_td = row.find('.alias-control')

    targets_td.html($('<textarea class=alias-target-area rows=8 cols=40>')
              .val(row.data('targets').join('\n')))
    control_td.html('<a class=alias-save-button href=#>'+
                    '<i class="fa fa-2x fa-save"></i></a>')
    bind_save_row(row)
  }

  function handle_search_result(data, query) {
    var aliases = data.mail_aliases
      , parts = query.split('@', 2)
      , username = parts[0]
      , domain = parts[1]

    if (aliases.length === 0 && username && domain) {
      handle_create_new(username, domain)
    } else {
      update_table(aliases)
    }
  }

  function bind_save_row(row) {
    var save_button = row.find('.alias-save-button')

    save_button.click(function(e) {
      e.preventDefault()
      handle_save_row(row)
    })
  }

  function bind_edit_rows() {
    var rows = $('#alias-tbody tr')

    rows.each(function() {
      var row = $(this)
        , edit_button = row.find('.alias-edit-button')

      edit_button.click(function(e) {
        e.preventDefault()
        handle_edit_row(row)
      })
    })
  }

  function bind_form() {
    var form = $('#alias-form')

    form.submit(function(e) {
      e.preventDefault()
      var query = $('#alias-searchfield').val()
      $.ajax('/admin/mail_aliases/search',
             { method: 'GET'
             , data: { q: query }
             , error: console.log
             , success: function (data) { handle_search_result(data, query) }
             }
      )
    })
  }
  $(document).on('turbolinks:load', function() {
    $('.js-hide').hide()
    bind_form()
  })
}()
