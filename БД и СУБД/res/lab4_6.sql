-- Creating procedure

CREATE OR REPLACE PROCEDURE upsert_resources(_mu_name municipal_units.name%type, _animal_name animals.name%type, _number resources.number%type) AS -- Doesn't return anything ('void')
$$
    -- Variables
    DECLARE
        _mu_id municipal_units.id%type;
        _animal_id animals.id%type;
        _resource_id resources.id%type;
BEGIN
    -- Assign to variable
    -- If there are several rows, last row will be assigned
    -- If there are no rows, previous value will remain unchanged (will be NULL)
    SELECT id INTO _mu_id FROM municipal_units WHERE name = _mu_name;
    SELECT id INTO _animal_id FROM animals WHERE name = _animal_name;
    SELECT id INTO _resource_id FROM resources WHERE animal_id = _animal_id AND municipal_unit_id = _mu_id;

    IF _resource_id IS NULL THEN
        INSERT INTO resources(municipal_unit_id, animal_id, number)
        -- 'number' refers to column name
        VALUES (_mu_id, animal_id, _number);
    ELSE
        UPDATE resources SET number = _number WHERE id = _resource_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Call procedure
CALL upsert_resources('ГО г. Кунгур', 'Суслики', 2000);
