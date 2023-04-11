/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id integer NOT NULL GENERATED ALWAYS AS IDENTITY,
    name character varying(20),
    date_of_birth date,
    escape_attempts integer,
    neutered boolean,
    weigth_kg numeric,
    PRIMARY KEY (id)
);

ALTER TABLE animals
ADD species character varying(255);

/*Vet clinic database: query multiple tables*/

CREATE TABLE owners(
id INT GENERATED ALWAYS AS IDENTITY,
full_name VARCHAR(55),
age INT,
PRIMARY KEY (id)
);

CREATE TABLE species(
id INT GENERATED ALWAYS AS IDENTITY,
name VARCHAR(55),
PRIMARY KEY (id)
);

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT,
  ADD CONSTRAINT fk_species
  FOREIGN KEY (species_id)
  REFERENCES species (id);

ALTER TABLE animals ADD COLUMN owner_id INT,
  ADD CONSTRAINT fk_owners
  FOREIGN KEY (owner_id)
  REFERENCES owners (id);

/*Vet clinic database: add "join table" for visits*/
CREATE TABLE vets(
id INT GENERATED ALWAYS AS IDENTITY,
name VARCHAR(55),
age INT,
date_of_graduation DATE);

CREATE TABLE specializations (
    species_id INT,
    vets_id INT,
  CONSTRAINT fk_species FOREIGN KEY(species_id) REFERENCES species(id) ON DELETE CASCADE,
  CONSTRAINT fk_vets FOREIGN KEY(vets_id) REFERENCES vets(id) ON DELETE CASCADE);

CREATE TABLE visits (
    animals_id INT,
    vets_id INT,
    visit_date DATE,
  CONSTRAINT fk_animals FOREIGN KEY(animals_id) REFERENCES animals(id),
  CONSTRAINT fk_vets FOREIGN KEY(vets_id) REFERENCES vets(id));

/*Pair programing*/
/*Preparation*/

ALTER TABLE owners ADD COLUMN email VARCHAR(120);

/*Apply Indexes to improbe the preformance*/

CREATE INDEX animals_id_index ON visits(animal_id ASC);
CREATE INDEX vets_id_index ON visits(vet_id, animal_id, date_of_visit);
CREATE INDEX email_index ON owners(email ASC);