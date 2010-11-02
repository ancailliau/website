dba --repository=. --use=old sql:send "UPDATE activities SET id='tutoriels' WHERE id='tutoriels';"

dba --repository=. --use=old bulk:export --csv --type-safe --output=./snapshots/initial/people.csv mig_people 
dba --repository=. --use=old bulk:export --csv --type-safe --output=./snapshots/initial/events.csv mig_events 
dba --repository=. --use=old bulk:export --csv --type-safe --output=./snapshots/initial/event_registrations.csv mig_event_registrations 

dba --repository=. --use=devel bulk:import --truncate --csv --type-safe --input=./snapshots/initial/people.csv people 
dba --repository=. --use=devel bulk:import --truncate --ruby --type-safe --input=./snapshots/initial/activities.rb activities 
dba --repository=. --use=devel bulk:import --truncate --csv --type-safe --input=./snapshots/initial/events.csv events 
dba --repository=. --use=devel bulk:import --truncate --csv --type-safe --input=./snapshots/initial/event_registrations.csv event_registrations 
