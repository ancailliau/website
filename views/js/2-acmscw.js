function show_popup(url, width) {
	$.get(url, function(data) { 
		$('#popup').html(data); 
	  $('#popup').width(width);
		$('#popup').css("margin-left", "-" + (width/2) + "px");
		$('#popup').css("top", (50+$(window).scrollTop()) + "px");
		inside_height = $('#inside').height()+100;
		window_height = $(window).height();
		$('#hide').height(inside_height > window_height ? inside_height : window_height);
		$('#hide').width($(window).width());
	  $('#hide').show();
		$('#popup').show();
    $('html, body').animate( { scrollTop: 0 }, 'slow' );
	});
	return false;
}
function hide_popup(refresh) {
	$('#popup').hide();
  $('#hide').hide();
  if (refresh) { location.reload(true); }
	return false;
}  
function show_form(name, width) {
	show_popup("/forms/" + name, width);
	return false;
}