SELECT number
FROM animals
JOIN resources ON animals.id = resources.animal_id
JOIN municipal_units ON resources.municipal_unit_id = municipal_units.id
WHERE animals.name = 'Лось'
    AND municipal_units.name = 'Александровский муниципальный район'
