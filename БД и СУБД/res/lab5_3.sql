-- Операторный триггер

CREATE OR REPLACE FUNCTION update_animals_total_after_resources_insert() RETURNS trigger AS $$
BEGIN
    RAISE NOTICE '% % % %', tg_name, tg_when, tg_table_name, tg_op;
    UPDATE animals
    SET total = total + totals.sum_number
    FROM (SELECT animal_id, SUM(number) AS sum_number
          FROM new
          GROUP BY animal_id) AS totals
    WHERE animals.id = totals.animal_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS resources_after_insert ON resources;


CREATE TRIGGER resources_after_insert AFTER
INSERT ON resources REFERENCING new TABLE AS new
FOR EACH STATEMENT EXECUTE FUNCTION update_animals_total_after_resources_insert();


INSERT INTO resources(municipal_unit_id, animal_id, number)
VALUES (1,
        35,
        888), (9,
               35,
               2000);
