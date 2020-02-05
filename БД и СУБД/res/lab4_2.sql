-- ХФ

CREATE FUNCTION resources_number_by_name() RETURNS integer AS -- $$ аналогично @ в C#
 -- $xxx$ позволяет делать вложенные блоки
$proc1$
BEGIN
    RETURN (SELECT number
            FROM animals
                     JOIN resources
                          ON animals.id = resources.animal_id
                     JOIN municipal_units
                          ON resources.municipal_unit_id = municipal_units.id
            WHERE animals.name = 'Лось'
              AND municipal_units.name = 'Александровский муниципальный район');
END;
$proc1$ LANGUAGE plpgsql;

-- Calling from console or C#

SELECT resources_number_by_name();
