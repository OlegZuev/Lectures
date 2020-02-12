-- Операторный триггер

CREATE OR REPLACE FUNCTION update_animals_total_after_resources_delete() RETURNS trigger AS $$
BEGIN
    RAISE NOTICE '% % % %', tg_name, tg_when, tg_table_name, tg_op;
    UPDATE animals
    SET total = total - totals.sum_number
    FROM (SELECT animal_id, SUM(number) AS sum_number
          FROM old
          GROUP BY animal_id) AS totals
    WHERE animals.id = totals.animal_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS resources_after_delete ON resources;


CREATE TRIGGER resources_after_delete AFTER
DELETE ON resources REFERENCING new TABLE AS new
FOR EACH STATEMENT EXECUTE FUNCTION update_animals_total_after_resources_delete();

