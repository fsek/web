var galleryHook = function() {
  $('a#gallery_link').click(function() {
    var form = document.createElement("form");
    form.setAttribute("action", "http://foto.fsektionen.se/auth.php");
	  form.setAttribute("method", "post");
    var userField = document.createElement("input");
    var pwdField = document.createElement("input");
    gallery_secret = gallery_secret.split("$");
    gallery_secret = gallery_secret[gallery_secret.length - 1];
    userField.setAttribute("type", "hidden");
    userField.setAttribute("name", "username");
    userField.setAttribute("value", gallery_username);
    pwdField.setAttribute("type", "hidden");
    pwdField.setAttribute("name", "secret");
    pwdField.setAttribute("value", gallery_secret);
    form.appendChild(userField);
    form.appendChild(pwdField);
    document.body.appendChild(form);
    form.submit();
  });
}

$(document).ready(galleryHook);   
