var messages = new Array();
messages['user_must_be_logged'] = "Vous devez être connecté pour accéder/modifier ces informations";
messages['bad_rss_feed'] = "Votre flux RSS ne semble pas être une adresse web valide";
messages['server_error'] = "Une erreur est survenue. Veuillez réessayer plus tard";
messages['activation_request_ok'] = "<p>Un mail vous permettant de réactiver votre compte vous a été envoyé. Veuillez suivre les instructions s'y trouvant.</p>";
messages['newsletter_subscribe_ok'] = "Vous êtes maintenant inscrit";
messages['bad_user_or_password'] = "Utilisateur ou mot de passe invalide (<a href='/people/lost_password'>perdu?</a>)";
messages['missing_activation_key'] = "Clé d'activation manquante";
messages['activate_account_ok'] = "<p>Votre compte a été activé</p>";
messages['unknown_user'] = "Cette adresse email est inconnue dans notre base de données";
messages['bad_password'] = "Votre mot de passe doit comporter entre 8 et 15 caractères";
messages['event_registration_ok'] = "Vous êtes maintenant inscrit à cet événement!";
messages['subscribe_account_ok'] = "<p>Un mail vous permettant d'activer votre compte vous a été envoyé. Veuillez suivre les instructions s'y trouvant.</p>";
messages['click_here_to_register'] = "Cliquez-ici pour vous inscrire à cet événement";
messages['mail_already_in_use'] = "Cette adresse email est déjà utilisée";
messages['passwords_dont_match'] = "Les mots de passe ne correspondent pas";
messages['activation_required'] = "<p>Vous avez modifié votre adresse e-mail. Vous devez maintenant réactiver votre compte.<p>Un mail vous permettant d'activer votre compte vous a été envoyé. Veuillez suivre les instructions s'y trouvant.</p>";
messages['you_are_registered_to_this_event'] = "Vous êtes inscrit à cet événement!";
messages['unknown_event'] = "Cet événement n'est pas connu";
messages['invalid_email'] = "Adresse email invalide";
messages['bad_newsletter'] = "L'inscription a la newsletter est invalide";
messages['click_here_to_unregister'] = "Cliquez-ici pour vous désinscrire";
function activate_account() {
  form = "form#activate_account";
  $.ajax({type: "POST", url: "/webserv/people/activate_account", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/people/my_chapter";
        } else if (data[1] == 'activation_required') {
          window.location = "/feedback?mkey=activation_required";
        }
      } else if (data[0] == 'validation_ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').html(str);
      }
    }
  });
  return false;
}  
function login() {
  form = "form#login";
  $.ajax({type: "POST", url: "/webserv/people/login", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      if (data[0] == 'success') {
        if (data[1] == 'ok') {
          location.reload(true);
        }
      } else if (data[0] == 'validation_ko') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      }
    }
  });
  return false;
}  
function account_activation_request() {
  form = "form#account_activation_request";
  $.ajax({type: "POST", url: "/webserv/people/account_activation_request", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/feedback?mkey=activation_request_ok";
        }
      } else if (data[0] == 'validation_ko') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      }
    }
  });
  return false;
}  
function logout() {
  form = "form#logout";
  $.ajax({type: "POST", url: "/webserv/people/logout", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      location.reload(true);
    }
  });
  return false;
}  
function subscribe_account() {
  form = "form#subscribe_account";
  $.ajax({type: "POST", url: "/webserv/people/subscribe_account", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/feedback?mkey=subscribe_account_ok";
        }
      } else if (data[0] == 'validation_ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').html(str);
      }
    }
  });
  return false;
}  
function update_account() {
  form = "form#update_account";
  $.ajax({type: "POST", url: "/webserv/people/update_account", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/people/my_chapter";
        } else if (data[1] == 'activation_required') {
          window.location = "/feedback?mkey=activation_required";
        }
      } else if (data[0] == 'validation_ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').html(str);
      }
    }
  });
  return false;
}  
function newsletter_subscribe() {
  form = "form#newsletter_subscribe";
  $.ajax({type: "POST", url: "/webserv/people/newsletter_subscribe", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      if (data[0] == 'success') {
        if (data[1] == 'ok') {
          $(form + ' input').hide();
          $(form + ' .feedback').show();
          $(form + ' .feedback').html(messages['newsletter_subscribe_ok']);
        }
      } else if (data[0] == 'validation_ko') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      }
    }
  });
  return false;
}  
function register_to_this_event() {
  form = "form#register_to_this_event";
  $.ajax({type: "POST", url: "/webserv/event/register_to_this_event", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      location.reload(true);
    }
  });
  return false;
}  
function unregister_to_this_event() {
  form = "form#unregister_to_this_event";
  $.ajax({type: "POST", url: "/webserv/event/unregister_to_this_event", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      location.reload(true);
    }
  });
  return false;
}  
function register_by_mail() {
  form = "form#register_by_mail";
  $.ajax({type: "POST", url: "/webserv/event/register_by_mail", data: $(form).serialize(), dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error'
    },
    success: function(data) {
      if (data[0] == 'success') {
        if (data[1] == 'ok') {
          $(form + ' input').hide();
          $(form + ' .feedback').show();
          $(form + ' .feedback').html(messages['event_registration_ok']);
        }
      } else {
       $(form + ' .feedback').show();
       $(form + ' .feedback').html(messages[data[1][0]]);      }
    }
  });
  return false;
}  
