20.01.20

Открыли Visual Studio => учебная практика по БД и СУБД.
Не открыли VS => БД и СУБД.

# Базы данных

1. PostgreSQL.
2. SQLite - встраиваемая БД. Взаимодействие производится через библиотеки. Урезанная, не покрывает все возможности. Есть практически на всех устройствах. Пятая в мире часто используемая программа.
    - по умолчанию foreign keys не используются

## Отношение "многие со многими" (many to many)

При 1:M достаточно двух таблиц, в одной из которых повторяется первичный ключ.

При M:M двух таблиц недостаточно. Для представления отношений M:M нужна третья таблица. Причем у этого отношения появляются собственные атрибуты. При этом не для каждой строчки есть полная информация.

## Pooling ресурсов

На .NET платформе для подключения к БД используется __pooling-ресурс__. Есть множество подключений к БД. Платформа ищет открытое и неиспользуемое соединение. Если оно не нашлось, он открывает новое. При "закрытии" соединение помечается как "неактивное" и в течение какого-то времени не закрывается. Платформа может вернуть существующее неактивное подключение вместо открытия нового подключения.

# Наша программа

## Построим дерево

- Муниципальная единица
    - Животные - количество

При помощи операции дублирование отношение M:M можно развернуть в дерево.

## Подключение к БД

Для подключения к БД используется строка подключения.

## Вывод информации

```sql
SELECT municipal_units.name AS municipal_name,
       animals.name AS animal_name,
       resources.number
FROM animals
    INNER JOIN resources
        ON animals.id = resources.animal_id
    INNER JOIN municipal_units
        ON resources.municipal_unit_id = municipal_units.id
```

## Сортировка

Несмотря на то, что выводимые данные кажутся упорядоченными, это случайность.

```sql
SELECT municipal_units.name AS municipal_name,
       animals.name AS animal_name,
       resources.number
FROM animals
    INNER JOIN resources
        ON animals.id = resources.animal_id
    INNER JOIN municipal_units
        ON resources.municipal_unit_id = municipal_units.id
ORDER BY municipal_units.name, animals.name
```

## Идентификация

Нельзя смотреть на название муниципалитета, т. к. на нем нет ограничения уникальности. Нам надо использовать первичный ключ.

```sql
SELECT municipal_units.id AS municipal_id,
       municipal_units.name AS municipal_name,
       animals.name AS animal_name,
       resources.number
FROM animals
    INNER JOIN resources
        ON animals.id = resources.animal_id
    INNER JOIN municipal_units
        ON resources.municipal_unit_id = municipal_units.id
ORDER BY municipal_units.name,
         municipal_units.id,
         animals.name
```

## Выполнение команды

- ExecuteReader - множество из строк и столбцов.
- ExecuteNonQuery - "выполни не запрос на получение данных". Результат - не таблица. Пример: удаление.
- ExecuteScalar - результат - первая строчка первого столбца.

### Reader

Изначально находится на -1 строке. В начале работы мы просим его перейти на следующую строчку.

Как только мы стали на некую строчку, мы можем работать с ней как со словарем. Возвращает объект типа object.

```cs
// Возвращает объект типа object
string data = (string)reader["mu_name"];
```

Его следует оборачивать в using.

# Do's and dont's

1. Подключение к БД - ресурс исчерпаемый. БД может отказать в доступе.
2. Многократно открывать или закрывать соединение - плохо.
3. Держать соединение активный во время медленного пользовательского ввода - плохо.
