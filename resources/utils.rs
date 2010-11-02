date_of  lambda{|time| time && time.strftime('%d/%m/%Y');       }

time_of  lambda{|time| time && time.strftime('%H:%M');          }

time_str lambda{|time| time && time.strftime('%d/%m/%Y %H:%M'); }

summarize lambda{|text,nb|
  text.split(/\s+/)[0..nb].join(" ")
}

event_subscription_link lambda{|event, text|
  tuple = AcmScW::database[:webr_planned_events].filter(:id => event).first
  if tuple
    <<-EOF
      <a onclick="javascript:show_form('/events/register/#{event}', 460)">#{text}</a>
    EOF
  else
    ""
  end
}