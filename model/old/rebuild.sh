dropdb -U acmscw acmscw_old 
createdb -U acmscw --owner=acmscw --encoding=utf8 acmscw_old
psql -U acmscw acmscw_old < backups/acmscw_production.20101103.fulldump
dba --repository=.. --use=old sql:send --file=migration-views.sql
dba --repository=.. --use=old sql:send "UPDATE activities SET id='tutoriels' WHERE id='tutorials';"
dba --repository=.. --use=old sql:send "UPDATE events SET id='scienceinfuse-2010' WHERE id='scienceinfuse_2010';"
dba --repository=.. --use=old sql:send "UPDATE events SET id='finale-olympiades-2010' WHERE id='finale_olympiades_2010';"
dba --repository=.. --use=old sql:send "UPDATE events SET id='securite-vie-privee-2010' WHERE id='securite_vie_privee_2010';"
dba --repository=.. --use=old sql:send "UPDATE events SET id='computer-graphics-night-2010' WHERE id='computer_graphics_night_2010';"
dba --repository=.. --use=old sql:send "INSERT INTO events (id,activity,name,abstract,start_time,end_time,status) VALUES ('latex-2009','tutoriels','Formation Latex 2009','',now(),now(),'ended')"
dba --repository=.. --use=old sql:send "DELETE FROM events WHERE id='google_summer_code_2010';"
