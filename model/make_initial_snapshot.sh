dba --repository=. --use=old sql:send "UPDATE activities SET id='tutoriels' WHERE id='tutoriels';"
dba --repository=. --use=old sql:send "DELETE FROM events WHERE id='google_summer_code_2010';"

dba --repository=. --use=old bulk:export --csv --type-safe --output=./snapshots/initial/people.csv mig_people 
dba --repository=. --use=old bulk:export --csv --type-safe --output=./snapshots/initial/events.csv mig_events 
dba --repository=. --use=old bulk:export --csv --type-safe --output=./snapshots/initial/event_registrations.csv mig_event_registrations 

dba --repository=. --use=devel sql:send "DELETE FROM event_registrations"
dba --repository=. --use=devel sql:send "DELETE FROM events"
dba --repository=. --use=devel sql:send "DELETE FROM activities"
dba --repository=. --use=devel sql:send "DELETE FROM people"
dba --repository=. --use=devel bulk:import --csv --type-safe --input=./snapshots/initial/people.csv people 
dba --repository=. --use=devel bulk:import --ruby --type-safe --input=./snapshots/initial/activities.rb activities 
dba --repository=. --use=devel bulk:import --csv --type-safe --input=./snapshots/initial/events.csv events 
dba --repository=. --use=devel bulk:import --csv --type-safe --input=./snapshots/initial/event_registrations.csv event_registrations 
dba --repository=. --use=devel bulk:import --ruby --type-safe --update --input=snapshots/initial/events.rb events