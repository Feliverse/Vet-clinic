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
  
  /*Table many-to-many: historial_treatments*/

CREATE TABLE "historial_treatments"(
    "medical_history_id" INTEGER NOT NULL,
    "treatment_id" INTEGER NOT NULL
);

ALTER TABLE
    "patients" ADD PRIMARY KEY("id");
ALTER TABLE
    "invoice_items" ADD CONSTRAINT "invoice_items_invoice_id_foreign" FOREIGN KEY("invoice_id") REFERENCES "invoices"("id");
ALTER TABLE
    "medical_histories" ADD CONSTRAINT "medical_histories_patient_id_foreign" FOREIGN KEY("patient_id") REFERENCES "patients"("id");
ALTER TABLE
    "invoice_items" ADD CONSTRAINT "invoice_items_treatment_foreign" FOREIGN KEY("treatment") REFERENCES "treatments"("id");
ALTER TABLE
    "invoices" ADD CONSTRAINT "invoices_medical_history_id_foreign" FOREIGN KEY("medical_history_id") REFERENCES "medical_histories"("id");
ALTER TABLE
    "historial_treatments" ADD CONSTRAINT "historial_treatments_treatment_id_foreign" FOREIGN KEY("treatment_id") REFERENCES "treatments"("id");
ALTER TABLE
    "historial_treatments" ADD CONSTRAINT "historial_treatments_medical_history_id_foreign" FOREIGN KEY("medical_history_id") REFERENCES "medical_histories"("id");

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

/*Apply Indexes to improbe the performance*/
 
CREATE INDEX animals_id_index ON visits(animal_id ASC);
CREATE INDEX vets_id_index ON visits(vet_id, animal_id, date_of_visit);
CREATE INDEX email_index ON owners(email ASC);
