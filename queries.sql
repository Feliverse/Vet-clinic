/*Queries that provide answers to the questions from all projects.*/

SELECT name FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' and '2019-12-31';
SELECT name FROM animals WHERE neutered IS TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon','Pikachu');
SELECT name, escape_attempts FROM animals WHERE weigth_kg>10.5;
SELECT name FROM animals WHERE neutered IS TRUE;
SELECT name FROM animals WHERE name NOT IN ('Gabumon');
SELECT name FROM animals WHERE weigth_kg BETWEEN 10.4 and 17.3;

/*Vet clinic database: query and update animals table*/

BEGIN;
UPDATE animals SET species='unspecified';
SELECT * FROM animals;
ROLLBACK;

BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
UPDATE animals SET species='pokemon' WHERE species IS NULL;
COMMIT;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals WHERE date_of_birth>'2022-01-01';
SAVEPOINT dateOfBirth;
UPDATE animals SET weight_kg=-1*weight_kg;
ROLLBACK TO dateOfBirth;
UPDATE animals SET weight_kg=-1*weight_kg WHERE weight_kg<0;
COMMIT; 