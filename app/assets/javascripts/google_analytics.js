$(function() {
  return $(document).on('turbolinks:load', function() {
    if (ga) {
      ga('set', 'location', location.href.split('#')[0]);
      return ga('send', 'pageview', {
        'title': document.title
      });
    }
  });
});
