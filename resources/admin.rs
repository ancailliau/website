tab_and_csv lambda{|report, long_name, short_name|
<<-EOF
  <li>
    <a onclick="javascript:open_tab('/dba/#{report}.html', '#{long_name}')">#{short_name.to_s[0..25]}</a>
    <a href="/dba/#{report}.csv" target="_blank"><img src="images/csv_icon_small.gif"/></a>
  </li>
EOF
}
