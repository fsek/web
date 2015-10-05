!function() {
  function bindProposal(form) {
    var form = $(form)
      , pointsContainer = form.find('.proposal-points')
      , points = form.find('.proposal-point')
      , addLink = form.find('.proposal-add')
      , removeLink = form.find('.proposal-remove')

    addLink.click(function() {
      pointsContainer.append(points[0].outerHTML)
    })

    removeLink.click(function() {
      var freshPoints = $(points.selector)

      if (freshPoints.length !== 1) {
        freshPoints.last().remove()
      }
    })
  }

  $(function() {
    $('.proposal-form').each(function(_, e) { bindProposal(e) })
  })
}()
