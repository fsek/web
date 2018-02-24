$(document).on('turbolinks:load', function() {
  let page = $('#admin-pages-form');
  let btn = page.find('#element-type-btn');

  function switchElements() {
    if (btn.val() === 'text') {
      page.find('.image-element').hide();
      page.find('.text-element').show();
    } else if (btn.val() === 'image') {
      page.find('.text-element').hide();
      page.find('.image-element').show();
    }
  }

  switchElements();
  btn.on('change', switchElements);
});
