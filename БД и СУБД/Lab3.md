# Лаба 3

24.01.20

- [Лаба 3](#Лаба-3)
  - [Запросы](#Запросы)
  - [Сортировка](#Сортировка)
  - [Сравнение](#Сравнение)
    - [Оператор LIKE](#Оператор-like)
  - [Операции](#Операции)
    - [UNION](#union)
    - [INTERSECT](#intersect)
    - [EXCEPT](#except)
    - [LIMIT](#limit)
  - [Вывод информации о животных, информация о которых есть в таблице ресурсов](#Вывод-информации-о-животных-информация-о-которых-есть-в-таблице-ресурсов)
  - [Подзапросы](#Подзапросы)
  - [Соединения](#Соединения)
    - [INNER JOIN](#inner-join)
    - [CROSS JOIN](#cross-join)
    - [LEFT OUTER JOIN](#left-outer-join)
    - [RIGHT OUTER JOIN](#right-outer-join)
    - [FULL OUTER JOIN](#full-outer-join)
  - [Вычисления и группировки](#Вычисления-и-группировки)
    - [Вычисления](#Вычисления)
    - [Группировки](#Группировки)
  - [Do's and dont's](#dos-and-donts)
  - [Заметки](#Заметки)

## Запросы

```sql
SELECT *
FROM resources
WHERE number < 1000 AND number < 10
    OR number IN (100, 200)
```

## Сортировка

```sql
SELECT *
FROM resources
WHERE number < 1000 AND number < 10
    OR number IN (100, 200)
ORDER BY number DESC -- по убыванию
```

```sql
SELECT *
FROM resources
WHERE number < 1000 AND number < 10
    OR number IN (100, 200)
ORDER BY number DESC, id -- number по убыванию, id по возрастанию
```

## Сравнение

```sql
SELECT *
FROM municipal_units
WHERE name = 'ГО г. Кунгур' -- строки пишутся в одинарных кавычках
```

### Оператор LIKE

```sql
SELECT *
FROM municipal_units
WHERE address LIKE '614%
```

% - 0 или более любых символов.

```sql
SELECT *
FROM municipal_units
-- WHERE head LIKE '%людмила%'
WHERE head ILIKE '%людмила%'
```

LIKE регистрозависимый. ILIKE - нет.

```sql
SELECT *
FROM municipal_units
WHERE address LIKE '___000%
```

_ - один любой символ.

## Операции

### UNION

Объединение множеств первого и второго запросов

```sql
SELECT *
FROM municipal_units
WHERE address LIKE '614%'
UNION
SELECT *
FROM municipal_units
WHERE address LIKE '___000%
```

Оператор UNION удаляет дубликаты. Не сохраняет порядок

```sql
SELECT *
FROM municipal_units
WHERE address LIKE '614%'
UNION ALL
SELECT *
FROM municipal_units
WHERE address LIKE '___000%'
```

UNION ALL не удаляет дубликаты. Он просто добавляет строки снизу. Сохраняет порядок.

```sql
(SELECT *
FROM municipal_units
WHERE address LIKE '614%'
ORDER BY id DESC)
UNION ALL
(SELECT *
FROM municipal_units
WHERE address LIKE '___000%'
ORDER BY id desc)
```

### INTERSECT

Пересечение.

```sql
SELECT *
FROM municipal_units
WHERE address LIKE '614%'
INTERSECT
SELECT *
FROM municipal_units
WHERE address LIKE '___000%'
```

### EXCEPT

Вычитание.

```sql
SELECT *
FROM municipal_units
WHERE address LIKE '614%'
EXCEPT
SELECT *
FROM municipal_units
WHERE address LIKE '___000%'
```

### LIMIT

Возвращает n элементов.

Первая десятка:

```sql
SELECT *
FROM resources
ORDER BY id
LIMIT 10 -- первые 10
```

Вторая десятка:

```sql
SELECT *
FROM resources
ORDER BY id
LIMIT 10 -- первые 10
OFFSET 10 -- пропустить 10
```

Третья десятка:

```sql
SELECT *
FROM resources
ORDER BY id
LIMIT 10 -- первые 10
OFFSET 20 -- пропустить 20
```

## Вывод информации о животных, информация о которых есть в таблице ресурсов

1. Выберем те значения, идентификаторы которых принадлежат идентификаторам из таблицы ресурсов:

    ```sql
    SELECT name
    FROM animals
    WHERE id IN (
        SELECT animal_id
        FROM resources
    )
    ```

    Просто инвертировать:

    ```sql
    SELECT name
    FROM animals
    WHERE id NOT IN ( -- NOT
        SELECT animal_id
        FROM resources
    )
    ```

2. Возьмем названия тех животных, для которых есть хотя бы одна строчка в таблице ресурсов, которая относится к данному животному:

    ```sql
    SELECT name
    FROM animals
    WHERE EXISTS(
        SELECT *
        FROM resources
        WHERE resources.animal_id = animals.id
        -- LIMIT 1 можно не писать, т. к. СУБД сама поймет, что после нахождения первой строчки EXISTS() вернет TRUE
    )
    ```

    EXISTS() истинно, если в аргументе есть хоть одна строчка.

    Просто инвертировать:

    ```sql
    SELECT name
    FROM animals
    WHERE NOT EXISTS( -- NOT
        SELECT *
        FROM resources
        WHERE resources.animal_id = animals.id
        -- LIMIT 1 можно не писать, т. к. СУБД сама поймет, что после нахождения первой строчки EXISTS() вернет TRUE
    )
    ```

3. Дерево

    ```sql
    SELECT DISTINCT name -- DISTINCT убирает повторы
    FROM animals
    JOIN resources ON animals.id = resources.animals_id
    ```

    ```sql
    SELECT DISTINCT ON (animals.id) name -- DISTINCT убирает повторы с одинаковым id
    FROM animals
    JOIN resources ON animals.id = resources.animals_id
    ```

    ```sql
    SELECT DISTINCT ON (animals.id) animals.name,
                                    municipal_units.id,
                                    number
    FROM animals
    JOIN resources
        ON animals.id = resources.animals_id
    JOIN municipal_units
        ON resources.municipal_unit_id = minicipal_units.id
    ```

    Выдает название животного, название муниципального образования и численность. При этом каждое животное выводится только один раз (случайную строку).

    Сложно инвертировать

## Подзапросы

1. Отсортировать таблицу

    ```sql
    SELECT *
    FROM resources
    ORDER BY number DESC
    LIMIT 1
    ```

    Вернет только одно значение.

    Если элементов несколько, то вернет случайное.

2. Больше или равно. Взять численность, которая не меньше всех других.

    ```sql
    SELECT *
    FROM resources
    WHERE number >= ALL (
        SELECT number
        FROM resources
    )
    ```

    Вернет все подходящие элементы (возможно, больше 1).

3. Больше. Подзапросы

    ```sql
    SELECT *
    FROM resources
    WHERE number > ALL ( -- отфильтруется все
        SELECT number
        FROM resources
    )
    ```

    ```sql
    SELECT * -- вернет все
    FROM resources
    WHERE number > ALL ( -- всегда истинно
        SELECT number
        FROM resources
        WHERE resources.id <> resources.id -- всегда ложно
    )
    ```

    ```sql
    SELECT *
    FROM resources AS r1 -- alias
    WHERE number > ALL (
        SELECT number
        FROM resources AS r2 -- alias
        WHERE r1.id <> r2.id
    )
    ```

    Если будет несколько строк с одинаковым значением, то не вернется ни одна строка.

4. Максимум. Взять максимальное значение

    ```sql
    SELECT *
    FROM resources
    WHERE number = (
        SELECT MAX(number)
        FROM resources
    )
    ```

## Соединения

### INNER JOIN

```sql
SELECT *
FROM animals
INNER JOIN resources ON animals.id = resources.animal_id
```

### CROSS JOIN

Декартово произведение - каждая строка соединяется с каждой строкой.

```sql
SELECT *
FROM animals
CROSS JOIN resources
```

```sql
SELECT *
FROM animals, resources -- ',' заменяется на CROSS JOIN
```

```sql
SELECT *
FROM animals
CROSS JOIN resources
WHERE animals.id = resources.animal_id -- аналогично INNER JOIN
```

```sql
SELECT *
FROM animals, resources
    -- ...
    -- Плохой вариант
WHERE animals.id = resources.animal_id
    AND number > 1000;
```

INNER JOIN можно выразить через CROSS JOIN:

```sql
SELECT *
FROM animals
INNER JOIN resources ON TRUE
```

### LEFT OUTER JOIN

Левая строчка останется, даже если недосоединилась с правой.

```sql
SELECT *
FROM animals
LEFT OUTER JOIN resources ON animals.id = resources.animal_id
```

Мы не теряем данные из левой таблицы, если нет соответствия в правой таблице.

### RIGHT OUTER JOIN

```sql
SELECT *
FROM animals
RIGHT OUTER JOIN resources ON animals.id = resources.animal_id
```

### FULL OUTER JOIN

```sql
SELECT *
FROM animals
LEFT OUTER JOIN resources ON animals.id = resources.animal_id -- аналогично INNER JOIN
INNER JOIN municipal_units ON resources.municipal_unit_id = municipal_units.id
```

```sql
SELECT *
FROM animals
LEFT OUTER JOIN resources ON animals.id = resources.animal_id -- аналогично INNER JOIN
RIGHT OUTER JOIN municipal_units ON resources.municipal_unit_id = municipal_units.id
```

```sql
SELECT *
FROM animals
LEFT OUTER JOIN resources ON animals.id = resources.animal_id
FULL OUTER JOIN municipal_units ON resources.municipal_unit_id = municipal_units.id
```

## Вычисления и группировки

### Вычисления

```sql
SELECT 2 + 2 -- 4
```

```sql
SELECT id,
       municipal_unit_id,
       animal_id,
       number * 1000, -- ключа нет
       modified_date
FROM resources
```

```sql
SELECT id,
       municipal_unit_id,
       animal_id,
       number * 1000 AS number_th, -- alias
       modified_date
FROM resources
```

```sql
SELECT max(resources.number)
FROM resources
```

```sql
SELECT count(*) -- посчитать число строк
FROM resources
```

Количество различных животных, о которых есть сведения:

```sql
SELECT count(DISTINCT animal_id)
FROM resources
```

### Группировки

Хотим посчитать общее количество животных:

```sql
SELECT animals.*, SUM(number), COUNT(*)
FROM resources
         INNER JOIN animals ON resources.animal_id = animals.id
GROUP BY animals.id
```

```sql
SELECT animals.*, SUM(number), COUNT(*)
FROM resources
         INNER JOIN animals ON resources.animal_id = animals.id
WHERE name LIKE 'Б%' -- идет перед GROUP BY
GROUP BY animals.id
```

```sql
SELECT animals.*, SUM(number), COUNT(*)
FROM resources
         INNER JOIN animals ON resources.animal_id = animals.id
WHERE name LIKE 'Б%' -- фильтруем построчно
GROUP BY animals.id
HAVING SUM(number) > 10000 -- фильтруем уже группы
```

```sql
SELECT animals.*, SUM(number), COUNT(*)
FROM resources
         INNER JOIN animals ON resources.animal_id = animals.id
WHERE name LIKE 'Б%'
GROUP BY animals.id
HAVING SUM(number) > 10000
ORDER BY SUM(number) DESC -- можно сортировать после GROUP BY
```

## Do's and dont's

1. Не использовать "SELECT *", т. к. изменения в БД могут сломать программу.

2. Нельзя открывать два Reader одновременно.

3. Не стоит обращаться к БД многократно без веской причины.

## Заметки

1. RIGHT OUTER JOIN отсутствует в SQLite. Надо использовать LEFT OUTER JOIN и поменять таблицы местами.
