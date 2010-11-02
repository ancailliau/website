date_of  lambda{|time| time && time.strftime('%d/%m/%Y');       }

time_of  lambda{|time| time && time.strftime('%H:%M');          }

time_str lambda{|time| time && time.strftime('%d/%m/%Y %H:%M'); }

summarize lambda{|text,nb|
  text.split(/\s+/)[0..nb].join(" ")
}

event_subscription_link lambda{|event, text|
  tuple = AcmScW::database[:webr_planned_events].filter(:id => event).first
  href = if tuple
    if tuple[:remaining_places].nil? or (tuple[:remaining_places] > 0)
      "javascript:show_form('/events/register/#{event}', 460)"
    else
      "javascript:show_message('/events/no-place-remaining')"
    end
  else
    "javascript:show_message('/events/past-event')"
  end
  "<a onclick=\"#{href}\">#{text}</a>"
}