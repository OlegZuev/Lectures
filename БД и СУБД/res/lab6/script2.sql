CREATE VIEW animals_nz_view AS
SELECT *
FROM animals
WHERE total <> 0;


CREATE VIEW animals_another_view AS
SELECT *
FROM animals_nz_view
WHERE name ILIKE 'Б%'
ORDER BY total DESC;


SELECT *
FROM animals_another_view;

