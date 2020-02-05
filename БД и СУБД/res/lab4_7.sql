CREATE OR REPLACE PROCEDURE upsert_resources(_mu_name municipal_units.name%type, _animal_name animals.name%type, _number resources.number%type) AS $$
    DECLARE
        _mu_id municipal_units.id%type;
        _animal_id animals.id%type;
BEGIN
    SELECT id INTO _mu_id FROM municipal_units WHERE name = _mu_name;
    SELECT id INTO _animal_id FROM animals WHERE name = _animal_name;

    INSERT INTO resources(municipal_unit_id, animal_id, number)
    VALUES (_mu_id, animal_id, _number)
    -- Postgres-specific
    -- Postgres increment counter - can lead to lots of 'holes'
    -- It is equivalent to 'try-catch'
    ON CONFLICT(municipal_unit_id, animal_id) DO UPDATE SET number = excluded.number;

    -- This works too:
    -- ON CONFLICT(municipal_unit_id, animal_id) DO UPDATE SET number = _number;
END;
$$ LANGUAGE plpgsql;

CALL upsert_resources('ГО г. Кунгур', 'Суслики', 2000);
