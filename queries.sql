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



