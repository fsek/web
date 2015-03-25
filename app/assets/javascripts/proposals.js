!function() {
  function bindProposal(form) {
    var form = $(form)
      , pointsContainer = form.find('.proposal-points')
      , firstPoint = pointsContainer.find('.proposal-point')
      , template = templateFrom(firstPoint)
      , addLink = form.find('.proposal-add')
      , removeLink = form.find('.proposal-remove')

    addLink.click(function() {
      pointsContainer.append(template)
    })
    removeLink.click(function() {
      pointsContainer.children().last().remove()
    })
  }

  function templateFrom(elem) {
    var html = elem.html()
    return html
  }

  $(function() {
    $('.proposal-form').each(function(_, e) { bindProposal(e) })
  })
}()
