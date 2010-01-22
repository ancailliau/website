/* This file is automatically generated by Waw. Any edit will probably be lost
 * next time the application is started. */

/* Messages, from waw.resources.messages */
var messages = new Array();
messages['activation_request_ok'] = "<p>Un e-mail vous permettant de réactiver votre compte vous a été envoyé. Veuillez suivre les instructions s'y trouvant.</p>";
messages['activation_required'] = "<p>Vous avez modifié votre adresse e-mail. Vous devez maintenant réactiver votre compte.<p>Un e-mail vous permettant d'activer votre compte vous a été envoyé. Veuillez suivre les instructions s'y trouvant.</p>";
messages['bad_newsletter'] = "L'inscription a la newsletter est invalide";
messages['bad_password'] = "Votre mot de passe doit comporter entre 8 et 15 caractères";
messages['bad_rss_feed'] = "Votre flux RSS ne semble pas être une adresse web valide";
messages['bad_user_or_password'] = "Utilisateur ou mot de passe invalide (<a href='/people/lost_password'>perdu?</a>)";
messages['click_here_to_register'] = "Cliquez-ici pour vous inscrire à cet événement";
messages['click_here_to_unregister'] = "Cliquez-ici pour vous désinscrire";
messages['contact_ok'] = "<p>Votre message nous a bien été envoyé. Nous y donnerons suite prochainement.</p>";
messages['event_registration_ok'] = "Vous êtes maintenant inscrit à cet événement!";
messages['invalid_birthdate'] = "Votre date de naissance doit respecter JJ/MM/AAAA";
messages['invalid_email'] = "Adresse e-mail invalide";
messages['mail_already_in_use'] = "Cette adresse e-mail est déjà utilisée";
messages['missing_activation_key'] = "Clé d'activation manquante";
messages['missing_message'] = "Le contenu de votre message ne peut pas être vide";
messages['missing_subject'] = "Le sujet de votre demande ne peut pas être vide";
messages['newsletter_subscribe_ok'] = "Vous êtes maintenant inscrit";
messages['olympiades_knowshow_other_missing'] = "Vous devez préciser la manière dont vous avez eu connaissance des olympiades";
messages['olympiades_mandatory_fields'] = "Les champs des deux premières sections sont tous obligatoires";
messages['olympiades_orientation_missing'] = "Vous devez préciser votre orientation d'étude";
messages['olympiades_orientation_other_missing'] = "Vous devez préciser votre orientation d'étude";
messages['olympiades_registration_ok'] = "<p>Nous avons bien reçu toutes vos données, votre inscription vous sera confirmée par e-mail.</p><p>Si vous n'avez pas reçu cette confirmation endéans les 5 jours, veuillez nous contacter sur <a href='mailto:info@uclouvain-acm-sc.be'>info@uclouvain-acm-sc.be</a></p>";
messages['passwords_dont_match'] = "Les mots de passe ne correspondent pas";
messages['server_error'] = "Une erreur est survenue. Veuillez réessayer plus tard";
messages['subscribe_account_ok'] = "<p>Un e-mail vous permettant d'activer votre compte vous a été envoyé. Veuillez suivre les instructions s'y trouvant.</p>";
messages['unknown_event'] = "Cet événement n'est pas connu";
messages['unknown_user'] = "Cette adresse e-mail est inconnue dans notre base de données";
messages['update_account_ok'] = "<p>Les informations vous concernant ont été mises à jour avec succès!</p>";
messages['user_must_be_logged'] = "Vous devez être connecté pour accéder/modifier ces informations";
messages['you_are_registered_to_this_event'] = "Vous êtes inscrit à cet événement!";

/* Actions contributed by AcmScW::Controllers::MainController, mapped to /webserv/main */
function webserv_main_send_message(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/main/send_message", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/feedback?mkey=contact_ok";
        }
      }
    }
  });
  return false;
}  
/* Actions contributed by AcmScW::Controllers::PeopleController, mapped to /webserv/people */
function webserv_people_account_activation_request(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/account_activation_request", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'validation-ko') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/feedback?mkey=activation_request_ok";
        }
      }
    }
  });
  return false;
}  
function webserv_people_activate_account(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/activate_account", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/people/account_activation_ok";
        } else if (data[1] == 'activation_required') {
          window.location = "/feedback?mkey=activation_required";
        }
      }
    }
  });
  return false;
}  
function webserv_people_login(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/login", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          location.reload(true);
        }
      }
    }
  });
  return false;
}  
function webserv_people_logout(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/logout", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      location.reload(true);
    }
  });
  return false;
}  
function webserv_people_newsletter_subscribe(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/newsletter_subscribe", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          $(form + ' input').hide();
          $(form + ' .feedback').show();
          $(form + ' .feedback').html(messages['newsletter_subscribe_ok']);
        }
      }
    }
  });
  return false;
}  
function webserv_people_subscribe_account(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/subscribe_account", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/feedback?mkey=subscribe_account_ok";
        }
      }
    }
  });
  return false;
}  
function webserv_people_update_account(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/update_account", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          $(form + ' .feedback').show();
          $(form + ' .feedback').html(messages['update_account_ok']);
        } else if (data[1] == 'activation_required') {
          window.location = "/feedback?mkey=activation_required";
        }
      }
    }
  });
  return false;
}  
/* Actions contributed by AcmScW::Controllers::EventController, mapped to /webserv/event */
function webserv_event_register_by_mail(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/event/register_by_mail", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
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
       $(form + ' .feedback').html(messages[data[1][0]]);}
    }
  });
  return false;
}  
function webserv_event_register_to_this_event(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/event/register_to_this_event", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      location.reload(true);
    }
  });
  return false;
}  
function webserv_event_unregister_to_this_event(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/event/unregister_to_this_event", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      location.reload(true);
    }
  });
  return false;
}  
/* Actions contributed by AcmScW::Controllers::OlympiadesController, mapped to /webserv/olympiades */
function webserv_olympiades_register(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/olympiades/register", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/feedback?mkey=server_error';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        str = '';
        str += '<ul>';
        for (var k in data[1]) {
          str += '<li>' + messages[data[1][k]] + '</li>';
        }
        str += '</ul>';
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(str);
      $('html, body').animate( { scrollTop: 0 }, 'slow' );
      
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          window.location = "/feedback?mkey=olympiades_registration_ok";
        }
      }
    }
  });
  return false;
}  
