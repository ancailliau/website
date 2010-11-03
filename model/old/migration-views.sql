DROP VIEW IF EXISTS mig_activities;
CREATE VIEW mig_activities AS 
     SELECT id, name, abstract, card_path 
       FROM activities;
DROP VIEW IF EXISTS mig_event_registrations;
CREATE VIEW mig_event_registrations AS 
     SELECT event, people 
       FROM event_registrations
      UNION 
     SELECT 'latex-2009' as event,
            P.id as people
	     FROM "LATEX_SUBSCRIPTIONS" as L
 INNER JOIN people as P ON L.mail = P.mail;
DROP VIEW IF EXISTS mig_events;
CREATE VIEW mig_events AS 
     SELECT id, activity, name, abstract, card_path, start_time, end_time, cast(null as integer) as nb_places, location, formal_location, cast(null as varchar(255)) as form_url 
       FROM events;
DROP VIEW IF EXISTS mig_people;
CREATE VIEW mig_people AS
     SELECT id, mail, md5(password) as password, cast(null as varchar(255)) as activation_key, adminlevel, first_name, last_name, occupation, newsletter, rss_feed, rss_status, current_timestamp as subscription_time 
       FROM people;
