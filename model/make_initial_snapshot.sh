dba --repository=. --use=old bulk:export --csv --type-safe --output=./snapshots/initial/people.csv mig_people 
dba --repository=. --use=old bulk:export --csv --type-safe --output=./snapshots/initial/events.csv mig_events 
dba --repository=. --use=old bulk:export --csv --type-safe --output=./snapshots/initial/event_registrations.csv mig_event_registrations 

dropdb   -U acmscw acmscw
createdb -U acmscw --owner=acmscw --encoding=utf8 acmscw
dba --repository=. --use=devel schema:sql-script create | dba --repository=. --use=devel sql:send

dba --repository=. --use=devel bulk:import --csv --type-safe --input=./snapshots/initial/people.csv people 
dba --repository=. --use=devel bulk:import --ruby --type-safe --input=./snapshots/initial/activities.rb activities 
dba --repository=. --use=devel bulk:import --csv --type-safe --input=./snapshots/initial/events.csv events 
dba --repository=. --use=devel bulk:import --csv --type-safe --input=./snapshots/initial/event_registrations.csv event_registrations 
dba --repository=. --use=devel bulk:import --ruby --type-safe --update --input=snapshots/initial/events.rb events
dba --repository=. --use=devel bulk:import --ruby --type-safe --input=snapshots/initial/url_rewriting.rb url_rewriting