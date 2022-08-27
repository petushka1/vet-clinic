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


