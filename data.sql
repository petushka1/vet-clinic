/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Agumon', '2020-02-03', 0, true, 10.23);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Gabumon', '2018-11-15', 2, true, 8);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Pikachu', '2021-01-07', 1, true, 15.04);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Devimon', '2017-05-12', 5, true, 11);

/* Milestone-2 */
/* Add more animals */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Charmander', '2020-02-08', 0, false, 11);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Plantmon', '2021-11-15', 2, true, 5.7);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Squirtle', '1993-04-02', 3, false, 12.13);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Angemon', '2005-06-12', 1, true, 45);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Boarmon', '2005-06-07', 7, true, 20.4);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Blossom', '1998-10-13', 3, true, 17);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Ditto', '2022-05-14', 4, true, 22);

/* Milestone-3 */
/* Remove column species from table animals */

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN owner_id INT;

INSERT INTO owner (full_name, age) VALUES ('Sam Smith', 34);
INSERT INTO owner (full_name, age) VALUES ('Jennifer Orwell', 19);
INSERT INTO owner (full_name, age) VALUES ('Bob', 45);
INSERT INTO owner (full_name, age) VALUES ('Melody Pond', 77);
INSERT INTO owner (full_name, age) VALUES ('Dean Winchester', 14);
INSERT INTO owner (full_name, age) VALUES ('Jodie Whittaker', 38);

INSERT INTO species (name) VALUES ('Pokemon');
INSERT INTO species (name) VALUES ('Digimon');

UPDATE animals 
SET species_id = (SELECT id FROM species WHERE name = 'Digimon') 
WHERE name LIKE '%mon';

UPDATE animals 
SET species_id = (SELECT id FROM species WHERE name = 'Pokemon')
WHERE name IS NULL;

UPDATE animals 
SET owner_id = (SELECT id FROM owner WHERE full_name = 'Sam Smith') 
WHERE name = 'Agumon';

UPDATE animals 
SET owner_id = (SELECT id FROM owner WHERE full_name = 'Jennifer Orwell') 
WHERE name IN ('Gabumon', 'Pikachu');

UPDATE animals 
SET owner_id = (SELECT id FROM owner WHERE full_name = 'Bob')
WHERE name IN ('Devimon', 'Plantmon');

UPDATE animals 
SET owner_id = (SELECT id FROM owner WHERE full_name = 'Melody Pond')
WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

UPDATE animals 
SET owner_id = (SELECT id FROM owner WHERE full_name = 'Dean Winchester')
WHERE name IN ('Angemon', 'Boarmon');

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



