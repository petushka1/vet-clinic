/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id GENERATED ALWAYS AS IDENTITY, 
    name varchar(100),
    date_of_birth date,
    escape_attempts INT,
    neutered boolean,
    weight_kg decimal,
/* add a new column 
ALTER TABLE animals
ADD COLUMN spacies VARCHAR(100); */
    spacies varchar(100)
);
