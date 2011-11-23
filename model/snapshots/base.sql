--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: acmscw; Tablespace: 
--

CREATE TABLE activities (
    abstract text NOT NULL,
    name text NOT NULL,
    card_path text,
    id text NOT NULL
);


ALTER TABLE public.activities OWNER TO acmscw;

--
-- Name: activity_responsabilities; Type: TABLE; Schema: public; Owner: acmscw; Tablespace: 
--

CREATE TABLE activity_responsabilities (
    people integer NOT NULL,
    kind text NOT NULL,
    "order" integer NOT NULL,
    activity text NOT NULL
);


ALTER TABLE public.activity_responsabilities OWNER TO acmscw;

--
-- Name: event_registrations; Type: TABLE; Schema: public; Owner: acmscw; Tablespace: 
--

CREATE TABLE event_registrations (
    people integer NOT NULL,
    event text NOT NULL
);


ALTER TABLE public.event_registrations OWNER TO acmscw;

--
-- Name: event_responsabilities; Type: TABLE; Schema: public; Owner: acmscw; Tablespace: 
--

CREATE TABLE event_responsabilities (
    people integer NOT NULL,
    kind text NOT NULL,
    event text NOT NULL,
    "order" integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.event_responsabilities OWNER TO acmscw;

--
-- Name: events; Type: TABLE; Schema: public; Owner: acmscw; Tablespace: 
--

CREATE TABLE events (
    form_url text,
    formal_location text,
    start_time timestamp without time zone NOT NULL,
    location text,
    activity text NOT NULL,
    abstract text NOT NULL,
    end_time timestamp without time zone NOT NULL,
    name text NOT NULL,
    card_path text,
    id text NOT NULL,
    nb_places integer,
    form_table text
);


ALTER TABLE public.events OWNER TO acmscw;

--
-- Name: latex_practical_registrations; Type: TABLE; Schema: public; Owner: acmscw; Tablespace: 
--

CREATE TABLE latex_practical_registrations (
    people integer NOT NULL,
    time_slot text NOT NULL,
    event text NOT NULL
);


ALTER TABLE public.latex_practical_registrations OWNER TO acmscw;

--
-- Name: people; Type: TABLE; Schema: public; Owner: acmscw; Tablespace: 
--

CREATE TABLE people (
    rss_feed text,
    subscription_time timestamp without time zone,
    activation_key text,
    newsletter boolean,
    password text,
    mail text NOT NULL,
    last_name text,
    occupation text,
    rss_status text,
    id integer NOT NULL,
    adminlevel integer DEFAULT (-1) NOT NULL,
    first_name text
);


ALTER TABLE public.people OWNER TO acmscw;

--
-- Name: webr_event_participants; Type: VIEW; Schema: public; Owner: acmscw
--

CREATE VIEW webr_event_participants AS
    SELECT r.event, p.id, p.mail, p.last_name, p.first_name, p.occupation FROM (people p JOIN event_registrations r ON ((p.id = r.people))) ORDER BY p.id;


ALTER TABLE public.webr_event_participants OWNER TO acmscw;

--
-- Name: rpt_latex_practical_registrations; Type: VIEW; Schema: public; Owner: acmscw
--

CREATE VIEW rpt_latex_practical_registrations AS
    SELECT w.event, w.id, w.mail, w.last_name, w.first_name, w.occupation, l.time_slot FROM (webr_event_participants w JOIN latex_practical_registrations l ON (((w.event = l.event) AND (w.id = l.people)))) ORDER BY w.id;


ALTER TABLE public.rpt_latex_practical_registrations OWNER TO acmscw;

--
-- Name: url_rewriting; Type: TABLE; Schema: public; Owner: acmscw; Tablespace: 
--

CREATE TABLE url_rewriting (
    long text NOT NULL,
    short text NOT NULL
);


ALTER TABLE public.url_rewriting OWNER TO acmscw;

--
-- Name: webr_activity_responsibles; Type: VIEW; Schema: public; Owner: acmscw
--

CREATE VIEW webr_activity_responsibles AS
    SELECT r.activity, p.id, p.mail, p.last_name, p.first_name, p.occupation FROM (people p JOIN activity_responsabilities r ON ((p.id = r.people))) ORDER BY p.id;


ALTER TABLE public.webr_activity_responsibles OWNER TO acmscw;

--
-- Name: webr_allregistered; Type: VIEW; Schema: public; Owner: acmscw
--

CREATE VIEW webr_allregistered AS
    SELECT people.id, people.mail, people.last_name, people.first_name, people.occupation FROM people ORDER BY people.id;


ALTER TABLE public.webr_allregistered OWNER TO acmscw;

--
-- Name: webr_newsletter; Type: VIEW; Schema: public; Owner: acmscw
--

CREATE VIEW webr_newsletter AS
    SELECT people.id, people.mail, people.last_name, people.first_name, people.occupation FROM people WHERE (people.newsletter = true) ORDER BY people.id;


ALTER TABLE public.webr_newsletter OWNER TO acmscw;

--
-- Name: webr_past_events; Type: VIEW; Schema: public; Owner: acmscw
--

CREATE VIEW webr_past_events AS
    SELECT events.form_url, events.formal_location, events.start_time, events.location, events.activity, events.abstract, events.end_time, events.name, events.card_path, events.id, events.nb_places FROM events WHERE (now() > events.end_time) ORDER BY events.start_time DESC;


ALTER TABLE public.webr_past_events OWNER TO acmscw;

--
-- Name: webr_planned_events; Type: VIEW; Schema: public; Owner: acmscw
--

CREATE VIEW webr_planned_events AS
    SELECT e.form_url, e.formal_location, e.start_time, e.location, e.activity, e.abstract, e.end_time, e.name, e.card_path, e.id, e.nb_places, (SELECT count(*) AS count FROM event_registrations r WHERE (r.event = e.id)) AS nb_participants, (e.nb_places - (SELECT count(*) AS count FROM event_registrations WHERE (event_registrations.event = e.id))) AS remaining_places FROM events e WHERE (e.end_time > now()) ORDER BY e.start_time;


ALTER TABLE public.webr_planned_events OWNER TO acmscw;

--
-- Name: webr_responsibles; Type: VIEW; Schema: public; Owner: acmscw
--

CREATE VIEW webr_responsibles AS
    SELECT p.id, p.mail, p.last_name, p.first_name, p.occupation FROM people p WHERE ((p.adminlevel > 0) OR (EXISTS (SELECT activity_responsabilities.people, activity_responsabilities.kind, activity_responsabilities."order", activity_responsabilities.activity FROM activity_responsabilities WHERE (activity_responsabilities.people = p.id)))) ORDER BY p.id;


ALTER TABLE public.webr_responsibles OWNER TO acmscw;

--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: acmscw
--

INSERT INTO activities VALUES ('Courtes conférences, éventuellement suivies de débat, et orientées grand public. Elle se déroulent typiquement un jour de semaine en soirée, à Louvain-la-Neuve.', 'Soirées-conférences à thème', '/activites/conferences', 'conferences');
INSERT INTO activities VALUES ('Organisées au sein de toute la communauté française, les olympiades regroupent s''adresse à la fois aux élèves de secondaire et aux étudiants du supérieur (1e bac).', 'Olympiades belges d''Informatique', '/activites/olympiades', 'olympiades');
INSERT INTO activities VALUES ('Organisé dans le cadre du Printemps des Sciences, ensemble d''activités de sensibilisation à l''informatique à l''intention des plus jeunes.', 'Weekend festival Scienceinfuse', '/activites/scienceinfuse', 'scienceinfuse');
INSERT INTO activities VALUES ('Présentations sur divers domaines plus ou moins avancés de l''informatique. Ceux-ci seront dispensés en français ou en anglais selon l''orateur et le public visé.', 'Tutoriels', '/activites/tutoriels', 'tutoriels');
INSERT INTO activities VALUES ('Évènements sociaux divers comme des soirées projection de films, des visites d''entreprise, des participations groupées à des concours de programmation ...', 'Social Events', 'socialevents', 'socialevents');
INSERT INTO activities VALUES ('Concours ponctuels d''algorithmique et de programmation.', 'Concours', '/activites/concours', 'concours');


--
-- Data for Name: activity_responsabilities; Type: TABLE DATA; Schema: public; Owner: acmscw
--



--
-- Data for Name: event_registrations; Type: TABLE DATA; Schema: public; Owner: acmscw
--



--
-- Data for Name: event_responsabilities; Type: TABLE DATA; Schema: public; Owner: acmscw
--



--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: acmscw
--

INSERT INTO events VALUES (NULL, NULL, '2009-11-30 14:00:00', 'Auditoire SUD 11', 'tutoriels', 'LaTeX est un langage de balisage utilisé pour composer des documents à l''allure professionelle. Ce système de composition de document est principalement utilisé par les mathématiciens, les scientifiques, les ingénieurs et ceux issus du monde académique ou industriel. Cette formation est divisée en deux parties, vous permettant ainsi de découvrir LaTeX progressivement.', '2009-11-30 16:00:00', 'Formation Latex 2009', '/activites/2009-2010/tutoriels/latex', 'latex-2009', NULL, NULL);
INSERT INTO events VALUES (NULL, NULL, '2010-03-27 14:00:00', 'UCL, Louvain-la-Neuve, Place des Sciences', 'scienceinfuse', 'Dans le cadre du Printemps des Sciences 2010, se déroule le samedi 27 et le dimanche 28 mars 2010 à Louvain-la-Neuve un ensemble d''activités de sensibilisation à l''informatique.', '2010-03-28 17:00:00', 'Weekend Festival Scienceinfuse 2010', '/activites/2009-2010/scienceinfuse', 'scienceinfuse-2010', NULL, NULL);
INSERT INTO events VALUES (NULL, NULL, '2010-05-12 14:00:00', 'UCL, Louvain-la-Neuve', 'olympiades', 'Les Finales des olympiades d''informatique 2010 se dérouleront à l''UCL, à Louvain-la-Neuve, le mercredi 12 mai 2010 de 14h à 19h. L''épreuve durera trois heures et la proclamation des gagnants sera faite le jour même, en fin de journée. Les deux concours comporteront deux parties : des questions sur papier et des questions à résoudre sur ordinateur. La journée se terminera par la cérémonie de remise des prix qui sera suivie d''un drink.', '2010-05-12 19:00:00', 'Finale des Olympiades d''informatique 2010', '/activites/2009-2010/olympiades/finales', 'finale-olympiades-2010', NULL, NULL);
INSERT INTO events VALUES (NULL, NULL, '2010-03-16 18:45:00', 'UCL, Louvain-la-Neuve, Auditoire SUD18', 'conferences', 'La première soirée de conférences à thème de l''UCLouvain ACM Student Chapter aura lieu le mardi 16 mars à Louvain-la-Neuve, dans l''auditoire SUD18. Cette soirée est composée de deux conférences dont le thème principal est la sécurité et la vie privée. Les deux orateurs de cette conférence sont Gildas Avoine et Luc Beirens.', '2010-03-16 22:00:00', 'Conférence : Sécurité et vie privée', '/activites/2009-2010/conferences/securite-vie-privee', 'securite-vie-privee-2010', NULL, NULL);
INSERT INTO events VALUES (NULL, NULL, '2010-03-09 18:00:00', 'UCL, Louvain-la-Neuve', 'tutoriels', '12 heures pour construire une implémentation d''un algorithme ou d''une technologie tournée vers l''infographie. Au long de cette nuit, le but est de construire, soi-même, un implémentation de l''un des quatre sujets proposés.', '2010-03-10 06:00:00', 'Computer Graphics Night 2010', '/activites/2009-2010/tutoriels/computer-graphics-night', 'computer-graphics-night-2010', NULL, NULL);
INSERT INTO events VALUES (NULL, NULL, '2010-11-15 16:00:00', 'Auditoire SUD 18', 'tutoriels', 'LaTeX est un langage de balisage utilisé pour composer des documents à l''allure professionelle. Ce système de composition de document est principalement utilisé par les mathématiciens, les scientifiques, les ingénieurs et ceux issus du monde académique ou industriel. Cette formation est divisée en deux parties, vous permettant ainsi de découvrir LaTeX progressivement.', '2010-11-15 18:15:00', 'Formation Latex 2010', '/activites/2010-2011/tutoriels/latex', 'latex-2010', NULL, NULL);
INSERT INTO events VALUES ('', NULL, '2010-12-14 14:00:00', 'Salle Intel', 'tutoriels', 'Le GRID est une infrastructure virtuelle formée d''un grand nombre machines sur lesquelles il est possible de faire tourner des calculs et applications distribuées. Nous vous proposons un atelier composé d''un cours théorique suivi d''exercices pratiques afin de vous apporter les premières bases au GRID.
                                                          Cette séance d''exercice s''effectuera sur l''infrastructure de calcul réparti de recherche maintenue par BELNET, BEGrid.', '2010-12-14 18:00:00', 'BEGRID Workshop', '/activites/2010-2011/tutoriels/begrid', 'begrid-2010', 16, '');
INSERT INTO events VALUES ('', NULL, '2010-12-02 19:30:00', 'BARB94', 'socialevents', 'Projection du film "H2G2 : le Guide du Voyageur Galactique", adaptation cinématographique de la célèbre trilogie en cinq volumes de Douglas Adams.  Ce chef-d''oeuvre de la culture geek, à voir ou à revoir, sera projeté dans une ambiance décontractée, suivi d''un petit drink. Le film sera projeté en version originale sous-titrée en Français.', '2010-12-02 23:00:00', 'Projection du film H2G2: Le Guide du Voyageur Galactique', '/activites/2010-2011/socialevents/projection-h2g2', 'projection-h2g2', 186, '');
INSERT INTO events VALUES ('activites/2010-2011/tutoriels/latex/practical-fields.wbrick', NULL, '2010-11-22 16:15:00', 'Salle Informatique IAO (Bâtiment Vinci)', 'tutoriels', 'La seconde partie de la formation Latex consiste en des sessions pratiques encadrées sur ordinateur. Il vous sera demandé de réaliser un document à l''aide de LaTeX. Plusieurs sessions identiques sont organisées durant toute une semaine. Une session plus avancée sur Beamer aura lieu mardi, en parallèle avec la session débutante.', '2010-11-26 16:00:00', 'Session pratiques de la formation Latex 2010', '/activites/2010-2011/tutoriels/latex', 'latex-practical-2010', NULL, 'latex_practical_registrations');
INSERT INTO events VALUES ('', NULL, '2011-02-02 16:00:00', 'Salle Intel', 'concours', 'Ce concours consiste à refaire une des journées des Olympiades Internationales d''Informatique, un concours de programmation destiné aux élèves du secondaire. Il s''agira d''une bonne occasion de se mesurer à leur niveau, dans les mêmes conditions qu''eux.', '2011-02-02 21:00:00', 'Premier concours d''algorithmique et de programmation', '/activites/2010-2011/concours/ioi-2010', 'ioi-2010', 35, '');
INSERT INTO events VALUES ('', NULL, '2011-02-21 18:30:00', 'Barb06, Place Ste Barbe 1, Louvain-la-Neuve', 'tutoriels', 'Mise en pratique des différentes techniques présentées durant la session théorique. A partir de cas concrets, chaque équipe analysera et planifiera les différentes fonctionnalités du projet. Attention, usage excessif de post-its et de collaboration games. Des sandwiches seront offert par l''un des sponsors. 30 places disponibles! ', '2011-02-21 21:30:00', 'Agile Campus Tour - Planification Workshop ', '/activites/2010-2011/tutoriels/agile-campus-tour/pratique', 'agile11-w1', 30, '');
INSERT INTO events VALUES ('', NULL, '2011-02-28 18:30:00', 'Salle Intel, Place Ste Barbe 2, Louvain-la-Neuve', 'tutoriels', 'Séance de développement en binôme. Initiation au développement piloté par le comportement et au refactoring de code. Préparez-vous a coder à deux sur la même machine et à bousculer votre manière habituelle de développer. Des sandwiches seront offert par l''un des sponsors. 30 places disponibles! ', '2011-02-28 21:30:00', 'Agile Campus Tour - Code Workshop', '/activites/2010-2011/tutoriels/agile-campus-tour/pratique', 'agile11-w2', 30, '');
INSERT INTO events VALUES ('', NULL, '2011-02-08 19:00:00', 'BARB 94', 'conferences', 'Cette soirée-débat a pour thème principal l''utilisation grandissante de systèmes dits intelligents dans le monde de demain. On pense notamment au monde du transport, des soins médicaux, de la gestion de l''eau, de la sécurité publique, des habitations, de l''énergie, ... tout cela géré d''une manière plus efficace. Cette soirée-débat, animée par Hans Van Mingroot (IBM), sera l''occasion de découvrir ce que le monde industriel fait dans ce domaine, et également l''occasion de partager et confronter vos idées et points de vue par rapport à ce sujet qui fait et fera notre avenir à tous.', '2011-02-08 21:30:00', 'Intelligent systems of the future: perspectives and opportunities', 'http://uclouvain.acm-sc.be/intelligent-systems', 'intelligent-systems', 186, '');
INSERT INTO events VALUES ('', NULL, '2011-02-10 13:00:00', 'Barb94, Place Ste Barbe 2, Louvain-la-Neuve', 'tutoriels', 'Nous avons tous, quel que soit notre activité, été confrontés à l''organisation seul ou en équipe d''un projet informatique. L''agile campus tour est un évènement totalement gratuit qui a pour but de vous proposer une autre manière d''analyser, planifier et exécuter un tel projet, et ce au travers de plusieurs sessions théoriques, mais aussi des ateliers en groupe. L''Agile se focalise avant tout sur la livraison d''une application "qui marche", en utilisant des itérations courtes et en mettant l''accent sur la collaboration entre les différents acteurs afin de s''assurer que les fonctionnalités ayant le plus de valeur sont développées en premier. 
                                                                                                                                                                                                                                        Durant cette première session théorique, nous passerons en revue les différents problèmes que l''on peut rencontrer dans un projet IT, présenterons le manifeste agile, en quoi il cherche a répondre à ces problèmes et expliquerons rapidement son histoire. Nous terminerons par le programme des autres sessions et quelques ressources pour ceux qui veulent aller plus loin. Les 4 sessions théoriques sont organisées de 13h à 13h55.', '2011-02-10 14:00:00', 'Agile Campus Tour - 4 sessions théoriques', '/agile-campus-tour', 'agile11-t1', 400, '');
INSERT INTO events VALUES ('', NULL, '2011-04-02 14:00:00', 'Salle de lecture du bâtiment des Sciences, Place des Sciences, Louvain-la-Neuve', 'scienceinfuse', 'Dans le cadre du Printemps des Sciences 2011, des activités de sensibilisation à l''informatique se dérouleront le weekend du 02 et 03 avril 2011 à Louvain-la-Neuve. Grands et petits pourront découvrir l''informatique sous plusieurs facettes.', '2011-04-03 18:30:00', 'Weekend Festival Scienceinfuse 2011', '/activites/2010-2011/scienceinfuse', 'scienceinfuse-2011', NULL, '');


--
-- Data for Name: latex_practical_registrations; Type: TABLE DATA; Schema: public; Owner: acmscw
--



--
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: acmscw
--

INSERT INTO people VALUES (NULL, '2011-11-23 16:39:51.165622', NULL, false, '50a9c7dbf0fa09e8969978317dca12e8', 'webmaster@acm-sc.be', 'webmaster', 'Webmaster', NULL, 1, 3, 'webmaster');


--
-- Data for Name: url_rewriting; Type: TABLE DATA; Schema: public; Owner: acmscw
--

INSERT INTO url_rewriting VALUES ('activites/2009-2010/conferences/securite-vie-privee', 'securite-vie-privee');
INSERT INTO url_rewriting VALUES ('activites/2009-2010/tutoriels/computer-graphics-night', 'cgn_2010');
INSERT INTO url_rewriting VALUES ('activites/2010-2011/tutoriels/latex', 'latex');
INSERT INTO url_rewriting VALUES ('activites/conferences', 'conferences');
INSERT INTO url_rewriting VALUES ('activites/olympiades', 'olympiades');
INSERT INTO url_rewriting VALUES ('activites/tutoriels', 'tutoriels');
INSERT INTO url_rewriting VALUES ('activites/2010-2011/socialevents/projection-h2g2', 'h2g2');
INSERT INTO url_rewriting VALUES ('activites/2010-2011/tutoriels/agile-campus-tour', 'agile-campus-tour');
INSERT INTO url_rewriting VALUES ('activites/2010-2011/conferences/intelligent-systems', 'intelligent-systems');
INSERT INTO url_rewriting VALUES ('activites/2010-2011/scienceinfuse', 'scienceinfuse');


--
-- Name: ak_people_mail; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT ak_people_mail UNIQUE (mail);


--
-- Name: pk_activities; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT pk_activities PRIMARY KEY (id);


--
-- Name: pk_activity_responsabilities; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY activity_responsabilities
    ADD CONSTRAINT pk_activity_responsabilities PRIMARY KEY (activity, people);


--
-- Name: pk_event_registrations; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY event_registrations
    ADD CONSTRAINT pk_event_registrations PRIMARY KEY (people, event);


--
-- Name: pk_event_responsabilities; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY event_responsabilities
    ADD CONSTRAINT pk_event_responsabilities PRIMARY KEY (event, people);


--
-- Name: pk_events; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT pk_events PRIMARY KEY (id);


--
-- Name: pk_latex_practical_registrations; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY latex_practical_registrations
    ADD CONSTRAINT pk_latex_practical_registrations PRIMARY KEY (people, event);


--
-- Name: pk_people; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT pk_people PRIMARY KEY (id);


--
-- Name: pk_url_rewriting; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY url_rewriting
    ADD CONSTRAINT pk_url_rewriting PRIMARY KEY (short);


--
-- Name: uniq_people_activation; Type: CONSTRAINT; Schema: public; Owner: acmscw; Tablespace: 
--

ALTER TABLE ONLY people
    ADD CONSTRAINT uniq_people_activation UNIQUE (activation_key);


--
-- Name: actres_which_people; Type: FK CONSTRAINT; Schema: public; Owner: acmscw
--

ALTER TABLE ONLY activity_responsabilities
    ADD CONSTRAINT actres_which_people FOREIGN KEY (people) REFERENCES people(id);


--
-- Name: astres_which_activity; Type: FK CONSTRAINT; Schema: public; Owner: acmscw
--

ALTER TABLE ONLY activity_responsabilities
    ADD CONSTRAINT astres_which_activity FOREIGN KEY (activity) REFERENCES activities(id);


--
-- Name: event_which_activity; Type: FK CONSTRAINT; Schema: public; Owner: acmscw
--

ALTER TABLE ONLY events
    ADD CONSTRAINT event_which_activity FOREIGN KEY (activity) REFERENCES activities(id);


--
-- Name: evtres_which_event; Type: FK CONSTRAINT; Schema: public; Owner: acmscw
--

ALTER TABLE ONLY event_registrations
    ADD CONSTRAINT evtres_which_event FOREIGN KEY (event) REFERENCES events(id);


--
-- Name: evtres_which_event; Type: FK CONSTRAINT; Schema: public; Owner: acmscw
--

ALTER TABLE ONLY event_responsabilities
    ADD CONSTRAINT evtres_which_event FOREIGN KEY (event) REFERENCES events(id);


--
-- Name: evtres_which_people; Type: FK CONSTRAINT; Schema: public; Owner: acmscw
--

ALTER TABLE ONLY event_registrations
    ADD CONSTRAINT evtres_which_people FOREIGN KEY (people) REFERENCES people(id);


--
-- Name: evtres_which_people; Type: FK CONSTRAINT; Schema: public; Owner: acmscw
--

ALTER TABLE ONLY event_responsabilities
    ADD CONSTRAINT evtres_which_people FOREIGN KEY (people) REFERENCES people(id);


--
-- Name: fk_latex_practical_registrations_refs_event_registration; Type: FK CONSTRAINT; Schema: public; Owner: acmscw
--

ALTER TABLE ONLY latex_practical_registrations
    ADD CONSTRAINT fk_latex_practical_registrations_refs_event_registration FOREIGN KEY (people, event) REFERENCES event_registrations(people, event);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

