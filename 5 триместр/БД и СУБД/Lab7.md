# Лаба 7

11.03.20

- [Лаба 7](#Лаба-7)
  - [Удаление данных из таблицы](#Удаление-данных-из-таблицы)
  - [Обычное представление](#Обычное-представление)
  - [Материализованное представление](#Материализованное-представление)
  - [Изменение данных через представления](#Изменение-данных-через-представления)
  - [Изменение данных через представление с использованием триггера](#Изменение-данных-через-представление-с-использованием-триггера)

## Удаление данных из таблицы

```sql
-- Создает таблицу. Не надо указывать атрибуты. Не создает ключи или индексы
CREATE TABLE foo AS
    (SELECT ...);

-- Очистка данных таблицы
-- Вариант 1
DELETE FROM foo;

-- Вариант 2
-- Позволяет удалить данные из таблицы, не проводя построчный просмотр данных
TRUNCATE foo;

-- Truncate осуществляется в нужном порядке
TRUNCATE foo, bar;

-- Залить данные
INSERT INTO foo(...)
SELECT ...;

-- Если текст SELECT ... забыли
-- Лучше брать из представления:
INSERT INTO foo(...)
SELECT * FROM view1;

-- Материализованные представления (реализованы не во всех СУБД)
-- Они позволяют сохранять некоторое текущее состояние системы и обновлять его по желанию
```

## Обычное представление

```sql
-- Суммарная численность животных для каждого МО
CREATE OR REPLACE VIEW mu_view AS
SELECT municipal_units.id,
       municipal_units.name,
       SUM(resources.number) AS sum
FROM municipal_units
         JOIN resources ON municipal_units.id = resources.municipal_unit_id
GROUP BY municipal_units.id
ORDER BY municipal_units.id;

DELETE
FROM resources
WHERE municipal_unit_id =
      (SELECT id
       FROM municipal_units
       WHERE name = 'ГО г. Кунгур');

SELECT *
FROM mu_view;

-- Аналогично SELECT * FROM (для PostgreSQL)
TABLE mu_view;
```

## Материализованное представление

```sql
-- Материализованное представление
CREATE MATERIALIZED VIEW mu_view_mat AS
SELECT municipal_units.id,
       municipal_units.name,
       SUM(resources.number) AS sum
FROM municipal_units
         JOIN resources ON municipal_units.id = resources.municipal_unit_id
GROUP BY municipal_units.id
ORDER BY municipal_units.id;

DELETE
FROM resources
WHERE municipal_unit_id =
      (SELECT id
       FROM municipal_units
       WHERE name = 'ГО г. Кунгур');

-- Аналогично обычному представлению
TABLE mu_view_mat;

-- Заставляет материализованное представление обновиться
REFRESH MATERIALIZED VIEW mu_view_mat;

INSERT INTO resources(municipal_unit_id, animal_id, number)
SELECT id, 1, 222
FROM municipal_units
WHERE name = 'ГО г. Кунгур';
```

## Изменение данных через представления

```sql
-- Обновляемое представление. Можем обновлять также, как и таблицы
CREATE VIEW mu_2_view AS
SELECT *
FROM municipal_units
WHERE id % 2 = 0
ORDER BY id DESC;

SELECT * FROM mu_2_view;

-- Производит обновление. Невозможно подменить представление его телом
UPDATE mu_2_view
SET name = 'Наше название 6'
WHERE name = 'Наше название 5';

-- Тоже работает
DELETE FROM mu_2_view
WHERE name = 'Наше название 6';

-- Тоже работает. Каждая вторая строка добавляется в VIEW, т. к. VIEW выводит только записи с четными id
INSERT INTO mu_2_view(name, head, address)
VALUES ('Наше название 8', 'Глава 8', 'Адрес 8');
```

```sql
-- Проверяет, что все изменения будут менять результаты представления
CREATE VIEW mu_2_view AS
SELECT *
FROM municipal_units
WHERE id % 2 = 0
ORDER BY id DESC
WITH CHECK OPTION;

-- Кидает ошибку, если вставка не изменит представление, т. е. каждый второй раз
INSERT INTO mu_2_view(name, head, address)
VALUES ('Наше название 8', 'Глава 8', 'Адрес 8');

-- Есть условия, при выполнении которых представление является изменяемым
```

## Изменение данных через представление с использованием триггера

```sql
-- Представление для добавления и обновления ресурсов
CREATE OR REPLACE VIEW mu_updatable_view AS
SELECT municipal_units.name AS mu_name,
       public.animals.name  AS animal_name,
       resources.number
FROM municipal_units
         JOIN resources ON municipal_units.id = resources.municipal_unit_id
         JOIN animals ON resources.animal_id = animals.id;

-- Триггерная функция
CREATE OR REPLACE FUNCTION mu_updatable_view_instead_of_insert_func()
    RETURNS trigger AS
$$
DECLARE
    _mu_id     municipal_units.id%type;
    _animal_id public.animals.id%type;
BEGIN
    SELECT id FROM municipal_units WHERE name = new.mu_name INTO _mu_id;
    SELECT id INTO _animal_id FROM animals WHERE name = new.animal_name;
    INSERT INTO resources(municipal_unit_id, animal_id, number)
    VALUES (_mu_id, _animal_id, new.number)
    ON CONFLICT (municipal_unit_id, animal_id) -- Ловит исключения
        DO UPDATE SET number = excluded.number;
    RETURN new; -- Для триггеров обычно пишут RETURN new. Если вернуть NULL, то в логах будет написано, что вставлено 0 строк
END;
$$
    LANGUAGE plpgsql;

-- Триггер INSTEAD OF INSERT
CREATE TRIGGER mu_updatable_view_instead_of_insert_tr
    INSTEAD OF INSERT
    ON mu_updatable_view
    FOR EACH ROW
EXECUTE FUNCTION mu_updatable_view_instead_of_insert_func();
```
