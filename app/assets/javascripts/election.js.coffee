goToByScroll = (id) ->
  $('html,body').animate { scrollTop: $(id).offset().top }, 'slow'

$('.collapse').on 'shown.bs.collapse', (e) ->
  goToByScroll '#views'
