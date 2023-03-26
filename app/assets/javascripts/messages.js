function showHide() {
    // ugly way to ensure that the scheduled time starts off hidden
    // but also have it show on soft reloads (such as incorrectly filled form)
    if (!$('#message_scheduled').is(':checked')) {
        $('.message_scheduled_time').hide()
    }
    $('#message_scheduled').click(function () {
        if ($(this).is(':checked')) {
            $('.message_scheduled_time').show()
        } else {
            $('.message_scheduled_time').hide()
        }
    })
}

$(document).on('turbolinks:load', showHide)
