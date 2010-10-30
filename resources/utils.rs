date_of  lambda{|time| time && time.strftime('%d/%m/%Y');       }

time_of  lambda{|time| time && time.strftime('%H:%M');          }

time_str lambda{|time| time && time.strftime('%d/%m/%Y %H:%M'); }

summarize lambda{|text,nb|
  text.split(/\s+/)[0..nb].join(" ")
}