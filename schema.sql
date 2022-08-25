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
