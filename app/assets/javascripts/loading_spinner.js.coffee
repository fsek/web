$ =>
startSpinner = ->
  $("html").css "cursor", "progress"
  return
stopSpinner = ->
  $("html").css "cursor", "auto"
  return
$(document).on "page:fetch", startSpinner
$(document).on "page:receive", stopSpinner