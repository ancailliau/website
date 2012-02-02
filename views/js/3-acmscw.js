function show_popup(url, width) {
	$.get(url + "?jsrequest=true", function(data) { 
		$('#popup').html(data); 
		$('#popup').show();
    $('html, body').animate( { scrollTop: 0 }, 'fast' );
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
	show_popup(name, width);
	return false;
}
function show_message(name) {
	show_popup(name, 300);
	return false;
}
function replace_form_content(form, msg) {
	$.get(msg + "?jsrequest=true", function(data) { 
    $(form).html(data);
  });
}
