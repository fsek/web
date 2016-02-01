$(function() {
  return $(document).on('page:change', function() {
    if (ga) {
      ga('set', 'location', location.href.split('#')[0]);
      return ga('send', 'pageview', {
        'title': document.title
      });
    }
  });
});
