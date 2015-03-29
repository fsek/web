$('.collapsing').on 'shown.bs.collapse', ->
  $('html,body').animate { scrollTop: $('#views').offset().top }, 'slow'
