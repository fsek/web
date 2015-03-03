$('input[type=\'checkbox\']#accepted_disclaimer').on 'change', ->
  if $('#accepted_disclaimer').is(':checked')
    $('.after_disclaimer').show()
  else
    $('.after_disclaimer').hide()