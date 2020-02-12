ALTER TABLE animals ADD total bigint NOT NULL DEFAULT 0;


UPDATE animals
SET total = totals.sum_number
FROM
    (SELECT animal_id,
            SUM(number) AS sum_number
     FROM resources
     GROUP BY animal_id) AS totals
WHERE animals.id = totals.animal_id;

