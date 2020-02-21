CREATE VIEW animals_nz_view AS
SELECT *
FROM animals
WHERE total <> 0;


SELECT *
FROM animals_nz_view
WHERE name ILIKE 'Б%'
ORDER BY total DESC;


SELECT *
FROM
    (SELECT *
     FROM animals
     WHERE total <> 0) AS t
WHERE name ILIKE 'Б%'
ORDER BY total DESC;

