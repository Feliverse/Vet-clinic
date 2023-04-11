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
SELECT species from animals;

BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
UPDATE animals SET species='pokemon' WHERE species IS NULL;
COMMIT;
SELECT species from animals;

BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT species from animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth>'2022-01-01';
SAVEPOINT dateOfBirth;
UPDATE animals SET weight_kg=-1*weight_kg;
ROLLBACK TO dateOfBirth;
UPDATE animals SET weight_kg=-1*weight_kg WHERE weight_kg<0;
COMMIT; 
SELECT * from animals;

/*How many animals are there?*/
SELECT COUNT(*) FROM animals;

/*How many animals have never tried to escape?*/
SELECT COUNT(*) FROM animals WHERE escape_attempts=0;

/*What is the average weight of animals?*/
SELECT AVG(weight_kg) FROM animals;

/*Who escapes the most, neutered or not neutered animals?*/
SELECT neutered, count(neutered) as result FROM animals GROUP BY neutered ORDER BY result DESC LIMIT 1;

/*What is the minimum and maximum weight of each type of animal?*/
SELECT species, MAX(weight_kg) AS max_weight, MIN(weight_kg) AS min_weight FROM animals GROUP BY species;

/*What is the average number of escape attempts per animal type of those born between 1990 and 2000?*/
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

/*Vet clinic database: query multiple tables*/
/*What animals belong to Melody Pond?*/
SELECT animals.name, owners.full_name FROM animals JOIN owners ON animals.owner_id=owners.id WHERE full_name='Melody Pond';

/*List of all animals that are pokemon (their type is Pokemon).*/
SELECT animals.name AS animal_name, species.name AS species_type FROM animals JOIN species ON animals.species_id=species.id WHERE species.name='Pokemon';

/*List all owners and their animals, remember to include those that don't own any animal.*/
SELECT full_name, animals.name FROM owners LEFT JOIN animals ON animals.owner_id=owners.id;

/*How many animals are there per species?*/
SELECT species.name, count(animals) FROM animals JOIN species ON animals.species_id=species.id GROUP BY species.name;

/*List all Digimon owned by Jennifer Orwell.*/
SELECT animals.name FROM animals JOIN owners ON animals.owner_id=owners.id WHERE owners.full_name='Jennifer Orwell';

/*List all animals owned by Dean Winchester that haven't tried to escape.*/
SELECT animals.name FROM animals JOIN owners ON animals.owner_id=owners.id WHERE owners.full_name='Dean Winchester' AND animals.escape_attempts=0 ;

/*Who owns the most animals?*/
SELECT owners.full_name , COUNT(animals.name) AS total_animals FROM owners JOIN animals ON animals.owner_id=owners.id GROUP BY owners.full_name ORDER BY total_animals DESC LIMIT 1;

/*Queries in join tables*/
/*Who was the last animal seen by William Tatcher?*/
SELECT v.date as visit_date, a.name, vt.name from visits v 
JOIN animals a ON v.animals_id=a.id 
JOIN vets vt ON v.vets_id=vt.id 
WHERE vt.name='William Tatcher' 
ORDER BY visit_date 
DESC LIMIT 1;

/*How many different animals did Stephanie Mendez see?*/
SELECT COUNT(a.name) from visits v 
JOIN animals a ON v.animals_id=a.id 
JOIN vets vt ON v.vets_id=vt.id 
WHERE vt.name='Stephanie Mendez';

/*List all vets and their specialties, including vets with no specialties.*/
SELECT species.name AS species_type, 
vt.name AS vet_name from specializations s 
JOIN species ON s.species_id=species.id FULL 
JOIN vets vt ON s.vets_id=vt.id;

/*List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.*/
SELECT v.date as visit_date, a.name 
AS animal_name, vt.name as vet_name from visits v 
JOIN animals a ON v.animals_id=a.id 
JOIN vets vt ON v.vets_id=vt.id 
WHERE vt.name='Stephanie Mendez' 
AND v.date BETWEEN '2020-04-01' AND '2020-08-30';

/*What animal has the most visits to vets?*/
SELECT a.name, COUNT(a.name) 
AS count_visits FROM visits v 
JOIN animals a ON v.animals_id=a.id 
JOIN vets vt ON v.vets_id=vt.id 
GROUP BY a.name 
HAVING COUNT(a.name) = (
  SELECT MAX(myf.count_visits) 
  FROM ( select a.name, COUNT(a.name) 
  AS count_visits from visits v 
  JOIN animals a ON v.animals_id=a.id 
  JOIN vets vt ON v.vets_id=vt.id 
  GROUP BY a.name) 
  AS myf
);

/*Who was Maisy Smith's first visit?*/
SELECT v.date as visit_day, a.name AS animal_name, vt.name AS vet_name 
FROM visits v JOIN animals a ON v.animals_id=a.id 
JOIN vets vt ON v.vets_id=vt.id 
WHERE vt.name='Maisy Smith' 
ORDER BY v.date LIMIT 1;

/*Details for most recent visit: animal information, vet information, and date of visit.*/
SELECT v.date as visit_day, 
a.name AS animal_name, 
vt.name AS vet_name 
FROM visits v 
JOIN animals a ON v.animals_id=a.id 
JOIN vets vt ON v.vets_id=vt.id 
ORDER BY v.date DESC LIMIT 1;

/*How many visits were with a vet that did not specialize in that animal's species?*/
SELECT count(*)
  FROM visits
  LEFT JOIN animals ON animals.id = visits.animals_id
  LEFT JOIN vets ON vets.id = visits.vets_id
  WHERE animals.species_id NOT IN (SELECT species_id FROM specializations WHERE vets_id = vets.id)

/*What specialty should Maisy Smith consider getting? Look for the species she gets the most.*/
SELECT species.name, count(*)
  FROM visits
  LEFT JOIN animals ON animals.id = visits.animals_id
  LEFT JOIN species ON animals.species_id = species.id
  LEFT JOIN vets ON vets.id = visits.vets_id
  WHERE vets.name = 'Maisy Smith'
  GROUP BY species.name;
  
  /*Pair programing*/
/*Before queries - te times of execusion are more than 1000 ms*/

EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';

/*After Index the times reduced significatly */
EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';

