-- Построчный триггер
-- Триггер - всегда функция
-- IUD - INSERT, UPDATE, DELETE

CREATE OR REPLACE FUNCTION update_animals_total_after_resources_iud() RETURNS trigger AS $$
BEGIN
    RAISE NOTICE '% % % %', tg_name, tg_when, tg_table_name, tg_op;
    IF tg_op IN ('INSERT', 'UPDATE') THEN
        UPDATE animals SET total = total + new.number WHERE id = new.animal_id;
    END IF;
    IF tg_op IN ('DELETE', 'UPDATE') THEN
        UPDATE animals SET total = total - old.number WHERE id = old.animal_id;
    END IF;
    -- В случае триггеров после операции вставки можно вернуть что угодно
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS resources_after_iud ON resources;

-- Построчный триггер

CREATE TRIGGER resources_after_iud -- Реагируем только на обновления отдельных столбцов
 AFTER
INSERT
OR
UPDATE OF animal_id, number
OR
DELETE ON resources -- Следующая строка добавляется по умолчанию
 -- Для построчного триггера переопределить нельзя - ограничения реализации
 -- REFERENCING OLD ROW as old NEW ROW as new
 --WHEN (  )

FOR EACH ROW EXECUTE FUNCTION update_animals_total_after_resources_iud();

