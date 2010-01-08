function newsletter_subscribe() {
	form = "form#newsletter_subscribe";
	$.ajax({type: "POST", url: "/services/newsletter_subscribe", data: $(form).serialize(), dataType: "json",
		error: function(data) {
			$('form#newsletter_subscribe input').hide();
			$('#newsletter_subscribe_feedback').show();
			$('#newsletter_subscribe_feedback').html(messages['server_error']);
		},
		success: function(data) {
			if (data[0] == "success") {
	  		$('form#newsletter_subscribe input').hide();
				$('#newsletter_subscribe_feedback').html(messages['newsletter_subscribe_ok']);
			} else if (data[0] == "validation_ko") {
			  $('#newsletter_subscribe_feedback').html(messages[data[1][0]]);
			} else {
				$('form#newsletter_subscribe input').hide();
				$('#newsletter_subscribe_feedback').show();
				$('#newsletter_subscribe_feedback').html(messages['server_error']);
		  }
		}
	});
	return false;
}
function account_activation_request() {
	form = "form#account_activation_request";
	$.ajax({type: "POST", url: "/services/account_activation_request", data: $(form).serialize(), dataType: "json",
		error: function(data) {
			$('form#account_activation_request input').hide();
			$('#account_activation_request_feedback').show();
			$('#account_activation_request_feedback').html(messages['server_error']);
		},
		success: function(data) {
			if (data[0] == "success") {
				window.location = "/feedback?mkey=activation_request_ok"
			} else if (data[0] == "validation_ko") {
    		  $('#account_activation_request_feedback').html(messages[data[1][0]]);
			} else {
				$('form#account_activation_request input').hide();
				$('#account_activation_request_feedback').show();
				$('#account_activation_request_feedback').html(messages['server_error']);
		  }
		}
	});
	return false;
}
function activate_account() {
	form = "form#activate_account";
	$.ajax({type: "POST", url: "/services/activate_account", data: $(form).serialize(), dataType: "json",
		error: function(data) {
			$('#activate_account_feedback').html(messages['server_error']);
		},
		success: function(data) {
			if (data[0] == "success") {
			  window.location = "/feedback?mkey=activate_account_ok"
			} else if (data[0] == "validation_ko") {
				str = "";
				str += "<ul>";
				for (var k in data[1]) {
					str += "<li>" + messages[data[1][k]] + "</li>";
				}
				str += "</ul>";
				$('#activate_account_feedback').html(str);
			} else {
  			$('#activate_account_feedback').html(messages['server_error']);
		  }
		}
	});
	return false;
}
function subscribe_account() {
	form = "form#subscribe_account";
	$.ajax({type: "POST", url: "/services/subscribe_account", data: $(form).serialize(), dataType: "json",
		error: function(data) {
			$('#subscribe_account_feedback').html(messages['server_error']);
		},
		success: function(data) {
			if (data[0] == "success") {
			  window.location = "/feedback?mkey=subscribe_account_ok"
			} else if (data[0] == "validation_ko") {
				str = "";
				str += "<ul>";
				for (var k in data[1]) {
					str += "<li>" + messages[data[1][k]] + "</li>";
				}
				str += "</ul>";
				$('#subscribe_account_feedback').html(str);
			} else {
  			$('#subscribe_account_feedback').html(messages['server_error']);
		  }
		}
	});
	return false;
}
function login() {
	form = "form#login";
	$.ajax({type: "POST", url: "/services/login", data: $(form).serialize(), dataType: "json",
		error: function(data) {
			$('#login_feedback').html(messages['server_error']);
		},
		success: function(data) {
			if (data[0] == "success") {
				if (data[1] == 'ok') {
				  location.reload(true);
				} else {
					$('#login_feedback').html(data[1]);
				}
			} else if (data[0] == "validation_ko") {
				$('#login_feedback').html(messages[data[1][0]]);
			} else {
  			$('#login_feedback').html(messages['server_error']);
		  }
		}
	});
	return false;
}
function logout() {
	$.ajax({type: "POST", url: "/services/logout", data: "", dataType: "json",
		error: function(data) {
		  location.reload(true);
		},
		success: function(data) {
		  location.reload(true);
		}
	});
	return false;
}
