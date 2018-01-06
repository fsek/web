$(function() {
	var ee = $(".event-errors")
	if(ee != null) {
		console.log(ee)
		var tabs = $(".new_event, .edit_event").find(".tab-pane");
		console.log(tabs)

		tabs.each(function() {
			console.log($(this))
			if($(this).find(".form-group").hasClass("has-error")) {
				ee.find('a[href="#' + $(this).attr('id')+'"]').parent(".list-group-item").addClass("event-error")
			}
		})
	}
})

