/* This file is automatically generated by Waw. Any edit will probably be lost
 * next time the application is started. */

/* Messages, from waw.resources.messages */
var messages = new Array();
messages['activation_request_ok'] = "<p>Un e-mail vous permettant de réactiver votre compte vous a été envoyé. Veuillez suivre les instructions s'y trouvant.</p>";
messages['activation_required'] = "<p>Vous avez modifié votre adresse e-mail. Vous devez maintenant réactiver votre compte.<p>Un e-mail vous permettant d'activer votre compte vous a été envoyé. Veuillez suivre les instructions s'y trouvant.</p>";
messages['bad_newsletter'] = "L'inscription a la newsletter est invalide";
messages['bad_password'] = "Votre mot de passe doit comporter entre 8 et 15 caractères";
messages['bad_passwords'] = "Mot de passe invalide ou non confirmé correctement";
messages['bad_rss_feed'] = "Votre flux RSS ne semble pas être une adresse web valide";
messages['bad_user_or_password'] = "Utilisateur ou mot de passe invalide";
messages['click_here_to_register'] = "Cliquez-ici pour vous inscrire à cet événement";
messages['click_here_to_unregister'] = "Cliquez-ici pour vous désinscrire";
messages['contact_ok'] = "<p>Votre message nous a bien été envoyé. Nous y donnerons suite prochainement.</p>";
messages['event_create_ok'] = "L'événement a été correctement créé";
messages['event_registration_ok'] = "Vous êtes maintenant inscrit à cet événement!";
messages['event_update_ok'] = "L'événement a été mis à jour";
messages['forbidden'] = "Vous ne pouvez pas accéder à cette information ou exécuter ce service.";
messages['invalid_birthdate'] = "Votre date de naissance doit respecter JJ/MM/AAAA et être une date valide";
messages['invalid_email'] = "Adresse e-mail invalide";
messages['invalid_event_abstract'] = "La description de l'événement est obligatoire";
messages['invalid_event_activity'] = "Activité inconnue";
messages['invalid_event_card_path'] = "Le lien vers la page explicative est obligatoire";
messages['invalid_event_end_time'] = "La date/heure de fin d'événement est invalide ou manquante";
messages['invalid_event_id'] = "Identifiant d'événement invalide (=~ /[a-z][a-z0-9-]+/) ou manquant";
messages['invalid_event_location'] = "Le lieu est obligatoire";
messages['invalid_event_name'] = "Le nom de l'événement est obligatoire";
messages['invalid_event_places'] = "Le nombre de place doit être un entier strictement positif";
messages['invalid_event_start_time'] = "La date/heure de début d'événement est invalide ou manquante";
messages['invalid_first_name'] = "Le prénom est obligatoire";
messages['invalid_last_name'] = "Le nom est obligatoire";
messages['invalid_long_url'] = "L'URL longue est obligatoire";
messages['invalid_short_url'] = "L'URL courte est obligatoire";
messages['mail_already_in_use'] = "Cette adresse e-mail est déjà utilisée";
messages['missing_activation_key'] = "Clé d'activation manquante";
messages['missing_message'] = "Le contenu de votre message ne peut pas être vide";
messages['missing_subject'] = "Le sujet de votre demande ne peut pas être vide";
messages['must_be_admin'] = "Vous devez être administrateur pour utiliser cette fonction";
messages['newsletter_subscribe_ok'] = "Vous êtes maintenant inscrit";
messages['olympiades_knowshow_other_missing'] = "Vous devez préciser la manière dont vous avez eu connaissance des olympiades";
messages['olympiades_mandatory_fields'] = "Les champs des deux premières sections sont tous obligatoires";
messages['olympiades_orientation_missing'] = "Vous devez préciser votre orientation d'étude";
messages['olympiades_orientation_other_missing'] = "Vous devez préciser votre orientation d'étude";
messages['olympiades_registration_ok'] = "<p>Nous avons bien reçu toutes vos données, votre inscription vous sera confirmée par e-mail.</p><p>Si vous n'avez pas reçu cette confirmation endéans les 5 jours, veuillez nous contacter sur <a href='mailto:info@uclouvain.acm-sc.be'>info@uclouvain.acm-sc.be</a></p>";
messages['send_results_announce_mail_ok'] = "Les mails annoncant les résultats des olympiades ont bien été envoyés.";
messages['server_error'] = "Une erreur est survenue. Veuillez réessayer plus tard";
messages['should_not_fail'] = "La validation de ce formulaire n'aurait pas du échouer.<br/> si le problème persiste, veuillez prendre contact avec le webmaster";
messages['subscribe_account_ok'] = "<p>Un e-mail vous permettant d'activer votre compte vous a été envoyé. Veuillez suivre les instructions s'y trouvant.</p>";
messages['unknown_event'] = "Cet événement n'est pas connu";
messages['unknown_user'] = "Cette adresse e-mail est inconnue dans notre base de données";
messages['update_account_ok'] = "<p>Les informations vous concernant ont été mises à jour avec succès!</p>";
messages['user_must_be_logged'] = "Vous devez être connecté pour accéder/modifier ces informations";
messages['you_are_registered_to_this_event'] = "Vous êtes inscrit à cet événement!";

/* Actions contributed by AcmScW::Controllers::PeopleController, mapped to / */
function webserv_people_account_activation_request(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/account_activation_request", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          show_message('/accounts/activation-request-ok')
        }
      } else if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      }
    }
  });
  return false;
}  
function webserv_people_activate_account(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/activate_account", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
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
          show_message('/accounts/activation-ok')
        } else if (data[1] == 'activation_required') {
          show_message('/accounts/activation-required')
        }
      } else if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      }
    }
  });
  return false;
}  
function webserv_people_login(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/login", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
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
      window.location = '/500';
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
      window.location = '/500';
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
      window.location = '/500';
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
          show_message('/accounts/subscribe-ok')
        }
      }
    }
  });
  return false;
}  
function webserv_people_update_account(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/people/update_account", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
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
          show_message('/accounts/update-ok')
        } else if (data[1] == 'activation_required') {
          show_message('/accounts/activation-required')
        }
      } else if (data[0] == 'error') {
        $(form + ' .feedback').show();
        $(form + ' .feedback').html(messages[data[1][0]]);
      }
    }
  });
  return false;
}  
/* Actions contributed by AcmScW::Controllers::AdminController, mapped to / */
function webserv_admin_add_url_rewriting(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/admin/add_url_rewriting", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
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
          show_message('/admin/main/add-url-rewriting-ok')
        }
      }
    }
  });
  return false;
}  
function webserv_admin_rm_url_rewriting(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/admin/rm_url_rewriting", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        show_message('/admin/main/rm-url-rewriting-ko')
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          show_message('/admin/main/rm-url-rewriting-ok')
        }
      }
    }
  });
  return false;
}  
function webserv_admin_update_url_rewriting(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/admin/update_url_rewriting", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
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
          show_message('/admin/main/update-url-rewriting-ok')
        }
      }
    }
  });
  return false;
}  
/* Actions contributed by AcmScW::Controllers::EventController, mapped to / */
function webserv_event_create(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/event/create", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
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
          show_message('/admin/events/create-ok')
        }
      }
    }
  });
  return false;
}  
function webserv_event_register_logged(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/event/register_logged", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        if (data[1] == 'no_remaining_place') {
          show_message('/events/no-place-remaining')
        } else if (data[1] == 'not_a_planned_event') {
          show_message('/events/past-event')
        } else {
         str = '';
         str += '<ul>';
         for (var k in data[1]) {
           str += '<li>' + messages[data[1][k]] + '</li>';
         }
         str += '</ul>';
         $(form + ' .feedback').show();
         $(form + ' .feedback').html(str);
        }
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          show_message('/events/registration-ok')
        }
      }
    }
  });
  return false;
}  
function webserv_event_register_notlogged(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/event/register_notlogged", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
    },
    success: function(data) {
      if (data[0] == 'validation-ko') {
        if (data[1] == 'no_remaining_place') {
          show_message('/events/no-place-remaining')
        } else if (data[1] == 'not_a_planned_event') {
          show_message('/events/past-event')
        } else {
         str = '';
         str += '<ul>';
         for (var k in data[1]) {
           str += '<li>' + messages[data[1][k]] + '</li>';
         }
         str += '</ul>';
         $(form + ' .feedback').show();
         $(form + ' .feedback').html(str);
        }
      } else if (data[0] == 'success') {
        if (data[1] == 'ok') {
          show_message('/events/registration-ok')
        }
      }
    }
  });
  return false;
}  
function webserv_event_update(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/event/update", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
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
          show_message('/admin/events/update-ok')
        }
      }
    }
  });
  return false;
}  
/* Actions contributed by AcmScW::Controllers::OlympiadesController, mapped to / */
function webserv_olympiades_register(request_data, form) {
  $.ajax({type: "POST", url: "/webserv/olympiades/register", data: request_data, dataType: "json",
    error: function(data) {
      window.location = '/500';
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
