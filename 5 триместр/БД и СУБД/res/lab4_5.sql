CREATE OR REPLACE FUNCTION resources_per_mu(mu_name municipal_units.name%type) RETURNS table ( animal_name animals.name%type, number resources.number%type ) AS $$
BEGIN
    RAISE NOTICE 'Called resources_per_mu(%)', mu_name;
    RETURN QUERY
        SELECT animals.name, resources.number
        FROM animals
            JOIN resources
                ON animals.id = resources.animal_id
            JOIN municipal_units
                ON resources.municipal_unit_id = municipal_units.id
        WHERE municipal_units.name = mu_name;
END;
$$ LANGUAGE plpgsql RETURNS NULL ON NULL INPUT;

-- Selects one column of pairs

SELECT resources_per_mu('Александровский муниципальный район');

-- Selects table

SELECT *
FROM resources_per_mu('Александровский муниципальный район');

-- Lateral join

SELECT *
FROM municipal_units
CROSS JOIN LATERAL resources_per_mu(municipal_units.name);
