/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id GENERATED ALWAYS AS IDENTITY, 
    name varchar(100),
    date_of_birth date,
    escape_attempts INT,
    neutered boolean,
    weight_kg decimal,
    owner_id INT,
    CONSTRAINT constraint_fk
      FOREIGN KEY(owner_id) 
	    REFERENCES owner(id)
        species_id INT,
    CONSTRAINT species_fk
      FOREIGN KEY(species_id) 
	    REFERENCES species(id)
);

/* Milestone-3 */

ALTER TABLE animals
DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN owner_id INT;

CREATE TABLE owner (
    id INT GENERATED ALWAYS AS IDENTITY, 
    full_name VARCHAR(100), 
    age INT, 
    PRIMARY KEY(id)
    );

CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY, 
    name VARCHAR(100), 
    PRIMARY KEY(id)
    );

/* Milestone-4 */
    CREATE TABLE vets (
        id  INT GENERATED ALWAYS AS IDENTITY,
        name VARCHAR(100),
        age INT,
        date_og_graduation  DATE NOT NULL,
        PRIMARY KEY (id)
    );

    CREATE TABLE specializations (
        species_id INT,
        vets_id INT,
        PRIMARY KEY (species_id, vets_id),
        FOREIGN KEY (vetS_id) REFERENCES vets (id) ON DELETE CASCADE,
        FOREIGN KEY (species_id) REFERENCES species (id) ON DELETE CASCADE
    );

  CREATE TABLE visits (
    animals_id INT,
    vets_id INT,
    visitation_date DATE NOT NULL,
    PRIMARY KEY (animals_id, vets_id, visitation_date),
    FOREIGN KEY (vets_id) REFERENCES vets (id) ON DELETE CASCADE,
    FOREIGN KEY (animals_id) REFERENCES animals (id) ON DELETE CASCADE
);

/* WEEK 2 */
/* Vet clinic database: database performance audit */

ALTER TABLE owner ADD COLUMN email VARCHAR(120);

ALTER TABLE visits DROP CONSTRAINT visits_pkey;
-- drop constrained for primary key to resolve duplicate pkey issue

-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animals_id, vets_id, visitation_date) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
INSERT INTO owner (full_name, email) SELECT 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';

/* Index all the animals rows in the visits table */
CREATE INDEX animals_index ON visits (animals_id DESC);

/* drop an index created for animals */
DROP INDEX animals_index;

/* Index all the vets rows in the visits table */
CREATE INDEX vets_index ON visits (vets_id DESC);

/* Index all the vets rows in the visits table */
CREATE INDEX email_index ON owner (email DESC);
