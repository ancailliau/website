dropdb -U acmscw acmscw_old 
createdb -U acmscw --owner=acmscw --encoding=utf8 acmscw_old
psql -U acmscw acmscw_old < backups/acmscw_production.20101103.fulldump
dba --repository=.. --use=old sql:send --file=migration-views.sql