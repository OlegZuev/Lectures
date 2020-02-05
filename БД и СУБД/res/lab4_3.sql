-- Parametrized stored function
-- CREATE FUNCTION resources_number_by_name(mu_name varchar(100), animal_name varchar(100))
 -- Inferring type from table

CREATE FUNCTION resources_number_by_name(mu_name varchar(100), animal_name animals.name%type) RETURNS integer AS $proc1$
BEGIN
    RETURN (SELECT number
            FROM animals
                     JOIN resources
                          ON animals.id = resources.animal_id
                     JOIN municipal_units
                          ON resources.municipal_unit_id = municipal_units.id
            WHERE animals.name = animal_name
              AND municipal_units.name = mu_name);
END;
$proc1$ LANGUAGE plpgsql;


SELECT resources_number_by_name('Александровский муниципальный район', 'Лось');


SELECT resources_number_by_name(animal_name := 'Лось', mu_name := 'Александровский муниципальный район');

-- Returns null

SELECT resources_number_by_name(animal_name := 'Лось2', mu_name := 'Александровский муниципальный район');

-- Returns null

SELECT resources_number_by_name('Александровский муниципальный район', NULL);
