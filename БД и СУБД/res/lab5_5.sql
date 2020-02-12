-- Операторный триггер

CREATE OR REPLACE FUNCTION update_animals_total_after_resources_update() RETURNS trigger AS $$
BEGIN
    RAISE NOTICE '% % % %', tg_name, tg_when, tg_table_name, tg_op;
    UPDATE animals
    SET total = total - totals.sum_number
    FROM (
             SELECT animal_id, SUM(signed_number) AS sum_number
             FROM (
                      SELECT animal_id, -number AS signed_number
                      FROM old
                      UNION ALL
                      SELECT animal_id, number
                      FROM new
                  ) AS tmp
             GROUP BY animal_id
         ) AS totals
    WHERE animals.id = totals.animal_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS resources_after_update ON resources;


CREATE TRIGGER resources_after_update AFTER
UPDATE ON resources REFERENCING new TABLE AS new
FOR EACH STATEMENT EXECUTE FUNCTION update_animals_total_after_resources_update();
