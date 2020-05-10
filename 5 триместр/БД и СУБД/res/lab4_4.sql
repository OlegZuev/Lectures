-- CREATE OR REPLACE replaces function if it's already created
 
CREATE OR REPLACE FUNCTION resources_number_by_name(mu_name varchar(100), animal_name animals.name%type) RETURNS integer AS $proc1$
BEGIN
    -- Print something
    -- Printf analog
    RAISE NOTICE 'Called resources_number_by_name(%, %)', mu_name, animal_name;

    RETURN (SELECT number
            FROM animals
                     JOIN resources
                          ON animals.id = resources.animal_id
                     JOIN municipal_units
                          ON resources.municipal_unit_id = municipal_units.id
            WHERE animals.name = animal_name
              AND municipal_units.name = mu_name);
END;
$proc1$ LANGUAGE plpgsql -- Returns null if one of the args is null
 -- Doesn't print line from line 8 because it doesn't enter function at all
 RETURNS NULL ON NULL INPUT;


SELECT name,
       resources_number_by_name('Александровский муниципальный район', name)
FROM animals;


SELECT resources_number_by_name('Александровский муниципальный район', 'Лось');


SELECT resources_number_by_name(animal_name := 'Лось', mu_name := 'Александровский муниципальный район');


SELECT resources_number_by_name(animal_name := 'Лось2', mu_name := 'Александровский муниципальный район');


SELECT resources_number_by_name('Александровский муниципальный район', NULL);
