function newsletter_subscribe() {
	form = "form#newsletter_subscribe";
	$.ajax({type: "POST", url: "/services/newsletter_subscribe", data: $(form).serialize(), dataType: "json",
	error: function(data) {
		$('form#newsletter_subscribe input').hide();
		$('#newsletter_subscribe_feedback').show();
		$('#newsletter_subscribe_feedback').html("Une erreur est survenue. Veuillez réessayer plus tard");
	},
	success: function(data) {
		if (data[0] == "success") {
  		$('form#newsletter_subscribe input').hide();
			$('#newsletter_subscribe_feedback').html("Vous êtes maintenant inscrit");
		} else if (data[0] == "validation_ko") {
		  $('#newsletter_subscribe_feedback').html("Adresse email invalide");
		} else {
			$('form#newsletter_subscribe input').hide();
			$('#newsletter_subscribe_feedback').show();
			$('#newsletter_subscribe_feedback').html("Une erreur est survenue. Veuillez réessayer plus tard");
	  }
	}});
	return false;
}
function account_activation_request() {
		form = "form#account_activation_request";
		$(form).submit(function() {
			$.ajax({type: "POST", url: "/services/account_activation_request", data: $(form).serialize(), dataType: "json",
				error: function(data) {
					$('form#account_activation_request input').hide();
					$('#account_activation_request_feedback').show();
					$('#account_activation_request_feedback').html("Une erreur est survenue. Veuillez réessayer plus tard");
				},
				success: function(data) {
					if (data[0] == "success") {
						window.location = "/feedback?mkey=activation_request_ok"
					} else if (data[0] == "validation_ko") {
      		  $('#account_activation_request_feedback').html("Adresse email invalide");
					} else {
						$('form#account_activation_request input').hide();
						$('#account_activation_request_feedback').show();
						$('#account_activation_request_feedback').html("Une erreur est survenue. Veuillez réessayer plus tard");
				  }
				}});
			return false;
		});
}