function cropAvatar() {
  $('#cropbox').cropper({
    aspectRatio: 1,
    crop: function(e) {
      $('#contact_crop_x').val(e.x);
      $('#contact_crop_y').val(e.y);
      $('#contact_crop_w').val(e.width);
      $('#contact_crop_h').val(e.height);
    }
  });
}

$(document).on('turbolinks:load', cropAvatar);
