tab_and_csv lambda{|report, long_name, short_name|
<<-EOF
  <li>
    <a onclick="javascript:open_tab('/dba/#{report}.html', '#{long_name}')">#{short_name.to_s[0..25]}</a>
    <a href="/dba/#{report}.csv" target="_blank"><img src="images/csv_icon_small.gif"/></a>
  </li>
EOF
}
date_of  lambda{|time| time && time.strftime('%d/%m/%Y');       }
time_of  lambda{|time| time && time.strftime('%H:%M');          }
time_str lambda{|time| time && time.strftime('%d/%m/%Y %H:%M'); }