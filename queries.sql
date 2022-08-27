/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT escape_attempts FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

/* Milestone-2
Update table through transactions */

BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals WHERE date_of_birth > DATE '2022-01-01';
SAVEPOINT PT1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SAVEPOINT PT1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

/* Queries */

SELECT COUNT(*) total FROM animals;
SELECT COUNT(*) escape_attempts_0 FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, SUM(escape_attempts) total FROM animals GROUP BY neutered ORDER BY total DESC;
SELECT MIN(weight_kg) min_weight, MAX(weight_kg) max_weight FROM animals GROUP BY species;
SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-01-01' GROUP BY species;

/* Milestone-3 */

SELECT a.* FROM animals a
    JOIN owner o ON o.id = a.owner_id
        WHERE o.full_name = 'Melody Pond';

SELECT a.* FROM animals a
    JOIN species s ON s.id = a.species_id
        WHERE s.name = 'Pokemon'; 

SELECT name n, full_name o_name FROM owner o 
    LEFT JOIN animals a ON a.owner_id = o.id
        ORDER BY o.id, o.full_name;

SELECT s.name species, COUNT(a.species_id) a_by_type 
    FROM animals a
        JOIN species s ON s.id = a.species_id
GROUP BY s.name, a.species_id;

SELECT a.* FROM animals a
        JOIN owner o ON o.id = a.owner_id
        JOIN species s ON s.id = a.species_id
WHERE o.full_name = 'Jennifer Orwel' AND s.name = 'Digimon';

SELECT a.* FROM animals a
    JOIN owner o ON o.id = a.owner_id
WHERE a.escape_attempts = 0;

SELECT t.*
    FROM (
        SELECT o.*, COUNT(o.id) total
        FROM owner o
        JOIN animals a ON a.owner_id = o.id
        GROUP BY o.id 
    ) AS t
    GROUP BY t.id, t.full_name, t.age, t.total
    HAVING t.total = (
        SELECT MAX(tt.total_animals)
        FROM (
            SELECT COUNT(s.id) total_animals
            FROM owner s
            JOIN animals a1 ON a1.owner_id = s.id
            GROUP BY s.id
        ) AS tt
    );

/* Milestone-4 */

/* Who was the last animal seen by William Tatcher? */

SELECT VISIT.animals_id, VISIT.last_visit, VISIT.animal_name 
    FROM (
        SELECT v.animals_id, v.vets_id, v.visitation_date last_visit, a.name animal_name
        FROM visits v 
        JOIN vets vet ON v.vets_id = vet.id
        JOIN animals a ON a.id = v.animals_id
        WHERE vet.name = 'William Tatcher' 
    ) AS VISIT
GROUP BY VISIT.animals_id, VISIT.animal_name, VISIT.last_visit
HAVING VISIT.last_visit = ( 
    SELECT MAX(VISIT2.visitation_date) FROM visits VISIT2
    JOIN vets v2 ON v2.id = VISIT2.vets_id
    WHERE v2.name = 'William Tatcher'
    GROUP BY VISIT2.vets_id
);

/* How many different animals did Stephanie Mendez see? */

SELECT VISIT.animal_name, VISIT.vets_id, VISIT.vet_name veterinar
    FROM (
        SELECT v.animals_id, v.vets_id, vet.name vet_name, a.name animal_name
        FROM visits v 
        JOIN vets vet ON v.vets_id = vet.id
        JOIN animals a ON a.id = v.animals_id
        WHERE vet.name = 'Stephanie Mendez'
    ) AS VISIT;


/* List all vets and their specialties, including vets with no specialties. */

SELECT v.id, v.name vet_name, X.specialized_on 
FROM vets v 
  LEFT JOIN (
    SELECT SPEC.vets_id, s.name specialized_on FROM specializations SPEC
      JOIN species s ON s.id = SPEC.species_id
  ) AS X
  ON X.vets_id = v.id 
ORDER BY v.id;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020 */

SELECT a.name, VISIT.visitation_date date, vet.name veterinar
FROM visits VISIT
JOIN animals a ON a.id = VISIT.animals_id
JOIN vets vet ON vet.id = VISIT.vets_id
WHERE vet.name = 'Stephanie Mendez'
GROUP BY date, a.name, veterinar
HAVING VISIT.visitation_date BETWEEN '2020-04-01' AND '2020-08-30';

/* What animal has the most visits to vets? */

SELECT COUNT(V.animals_id) max_visit, a.name animal_name, a.id
FROM visits V 
    JOIN animals a ON V.animals_id = a.id
GROUP BY a.id, animal_name
HAVING COUNT(V.animals_id) = (
    SELECT MAX(V2.total)
    FROM (
        SELECT COUNT(MV.animals_id) total 
        FROM visits MV
        GROUP BY MV.animals_id
    ) V2
);

/* Who was Maisy Smith's first visit? */

    SELECT v.visitation_date, vet.name veterinar, a.name animal
        FROM visits v 
        JOIN vets vet ON vet.id = v.vets_id
        JOIN animals a ON v.animals_id = a.id
        WHERE vet.name = 'Maisy Smith'
        GROUP BY  v.visitation_date, vet.name, a.name
        HAVING v.visitation_date = (SELECT MIN(VD.visitation_date)
        FROM visits VD
        JOIN vets vet2 ON vet2.id = VD.vets_id
    WHERE vet2.name = 'Maisy Smith'
    );

/* Details for most recent visit: animal information, vet information, and date of visit */

SELECT a.id animal_id, a.name animal_name, a.weight_kg animal_weight, v.id vet_id, v.name vet_name, 
  VISIT.visitation_date latest_visit
FROM visits VISIT
  JOIN vets v ON v.id = VISIT.vets_id 
  JOIN animals a ON a.id = VISIT.animals_id
WHERE VISIT.visitation_date = (SELECT MAX(visitation_date) FROM visits);

/* How many visits were with a vet that did not specialize in that animal's species? */

SELECT COUNT(RES.animal_type_id)
FROM (
SELECT v.id vet_id, a.id, a.species_id animal_type_id, VISIT.vets_id, VISIT.animals_id
    FROM visits VISIT 
    JOIN vets v ON VISIT.vets_id = v.id
    JOIN animals a ON a.id = VISIT.animals_id
) AS RES

JOIN specializations spec ON spec.vets_id = RES.vet_id
WHERE RES.animal_type_id <> spec.vets_id;

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */

SELECT RES2.name, RES2.count
FROM (
SELECT S.name, RES.animal_type_id, COUNT(RES.animal_type_id)
FROM (
    SELECT a.id animal_id, a.species_id animal_type_id 
    FROM visits VISIT 
    JOIN vets v ON v.id = VISIT.vets_id
    JOIN animals a ON a.id = VISIT.animals_id
    WHERE v.name = 'Maisy Smith'
) AS RES
JOIN species S ON S.id = RES.animal_type_id
GROUP BY S.name, RES.animal_type_id
) AS RES2
GROUP BY RES2.name, RES2.count
ORDER BY RES2.count DESC
LIMIT 1;


