-- public.film определение

-- Drop table

-- DROP TABLE film;

CREATE TABLE film (
	id int4 NOT NULL,
	"name" varchar NOT NULL,
	description varchar NULL,
	CONSTRAINT film_pk PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE film OWNER TO postgres;
GRANT ALL ON TABLE film TO postgres;


-- public.hall определение

-- Drop table

-- DROP TABLE hall;

CREATE TABLE hall (
	id int4 NOT NULL,
	"name" varchar NOT NULL,
	CONSTRAINT hall_pk_1 PRIMARY KEY (name, id)
);

-- Permissions

ALTER TABLE hall OWNER TO postgres;
GRANT ALL ON TABLE hall TO postgres;


-- public.hall_row определение

-- Drop table

-- DROP TABLE hall_row;

CREATE TABLE hall_row (
	id_hall int4 NOT NULL,
	"number" int2 NOT NULL,
	capacity int2 NOT NULL,
	"name" varchar NULL,
	CONSTRAINT hall_row_pk PRIMARY KEY (id_hall, number),
	CONSTRAINT hall_row_hall_fk FOREIGN KEY ("name",id_hall) REFERENCES hall("name",id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Permissions

ALTER TABLE hall_row OWNER TO postgres;
GRANT ALL ON TABLE hall_row TO postgres;


-- public.screening определение

-- Drop table

-- DROP TABLE screening;

CREATE TABLE screening (
	id int4 NOT NULL,
	hall_id int4 NOT NULL,
	film_id int4 NOT NULL,
	"time" timestamp NOT NULL,
	"name" varchar NULL,
	CONSTRAINT screening_pk PRIMARY KEY (id),
	CONSTRAINT screening_film_fk FOREIGN KEY (film_id) REFERENCES film(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT screening_hall_fk FOREIGN KEY ("name",hall_id) REFERENCES hall("name",id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Permissions

ALTER TABLE screening OWNER TO postgres;
GRANT ALL ON TABLE screening TO postgres;


-- public.tickets определение

-- Drop table

-- DROP TABLE tickets;

CREATE TABLE tickets (
	id_screening int4 NOT NULL,
	"row" int2 NOT NULL,
	seat int2 NOT NULL,
	"cost" int4 NOT NULL,
	CONSTRAINT tickets_pk PRIMARY KEY (id_screening, "row", seat),
	CONSTRAINT tickets_screening_fk FOREIGN KEY (id_screening) REFERENCES screening(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Permissions

ALTER TABLE tickets OWNER TO postgres;
GRANT ALL ON TABLE tickets TO postgres;
INSERT INTO public.film (id,"name",description) VALUES
	 (1,'Огниво','Приключение'),
	 (2,'Таро','Ужасы'),
	 (3,'Супер-Санта','Мультфильм');
INSERT INTO public.hall (id,"name") VALUES
	 (1,'Зал 1'),
	 (2,'Зал 2'),
	 (3,'Зал 3');
INSERT INTO public.hall_row (id_hall,"number",capacity,"name") VALUES
	 (1,1,10,NULL),
	 (1,2,15,NULL),
	 (1,3,20,NULL),
	 (2,2,15,NULL),
	 (3,2,12,NULL);
INSERT INTO public.screening (id,hall_id,film_id,"time","name") VALUES
	 (1,1,1,'2021-01-01 00:00:00',NULL),
	 (2,1,1,'2021-01-01 10:35:00',NULL),
	 (3,1,2,'2021-01-01 01:35:00',NULL),
	 (5,3,2,'2020-12-30 20:00:00',NULL),
	 (7,2,3,'2021-01-01 12:00:00',NULL),
	 (4,2,3,'2021-01-02 15:15:00',NULL),
	 (6,3,3,'2021-01-02 10:00:00',NULL);
INSERT INTO public.tickets (id_screening,"row",seat,"cost") VALUES
	 (2,4,15,100),
	 (3,5,15,100),
	 (4,6,15,100),
	 (5,7,15,100),
	 (1,2,10,150),
	 (1,3,15,200),
	 (1,3,6,150);

CREATE OR REPLACE VIEW public.capacity_hall_row
AS SELECT capacity
   FROM hall_row
  WHERE id_hall = 3 AND number = 2;
 
 CREATE OR REPLACE VIEW public.film_screening
AS SELECT film.name,
    hall.id,
    screening."time"
   FROM film,
    screening,
    hall
  WHERE screening."time" > '2021-01-01 11:00:00'::timestamp without time zone AND screening.film_id = film.id AND screening.hall_id = hall.id AND hall.id = 2;
 
 CREATE OR REPLACE VIEW public.films_screening
AS SELECT film.name,
    screening."time"
   FROM film,
    screening
  WHERE screening."time" > '2021-01-01 11:00:00'::timestamp without time zone AND screening.film_id = film.id;
 
 CREATE OR REPLACE VIEW public.screenings_film
AS SELECT screening.id AS screening_id,
    hall.name AS hall_name,
    screening."time"
   FROM screening
     JOIN film ON screening.film_id = film.id
     JOIN hall ON screening.hall_id = hall.id
  WHERE film.name::text = 'Таро'::text;

