/* Database schema to keep the structure of entire database. */
CREATE TABLE animals (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    name character varying(20),
    date_of_birth date,
    escape_attempts integer,
    neutered boolean,
    weigth_kg numeric,
    PRIMARY KEY (id)
)