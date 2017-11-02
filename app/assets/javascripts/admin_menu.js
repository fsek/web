$(function() {
	var children = $(".admin-menu-categories").find("li.menu-header").length;
	$(".admin-dropdown-menu").css("left", -children*5 + "vw");
});
