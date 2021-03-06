# Лаба 2

17.01.20

- [Лаба 2](#Лаба-2)
  - [Schemas (схемы)](#schemas-схемы)
  - [Именование](#Именование)
  - [Типы](#Типы)
  - [Опции](#Опции)
  - [Операции](#Операции)
  - [Дамп и восстановление](#Дамп-и-восстановление)
    - [Dump](#dump)
    - [Восстановление](#Восстановление)
  - [Заметки](#Заметки)

## Schemas (схемы)

В schemas можно складывать объекты БД. Schemas нужны для того, чтобы агрегировать объекты в коллекции.

Кросс-запросы между схемами не работают. Можно использовать кросс-запросы между схемами.

Схема public существует по умолчанию.

## Именование

Синтаксис регистро-независимый.
Именование переменных - snake case (lower snake case).

## Типы

int

bigint - аналог long

character(x) - строка. Если записываемое значение меньше ограничения сверху, то автоматически справа строка заполняется пробелами до нужного размера. x - ограничение по длине сверху.

- преимущества: точно известно, сколько место занимает значение.
- полезно, если есть столбец, в котором фиксированное количество символов.
- например, хэши (т. к. длина хэшей всегда фиксирована).

character varying(x) - хранит внутри длину конкретной строки и не дополняет строку пробелами справа.

char(x)/varchar(x) - встречается в других СУБД.

    Ограничения можно накладывать позднее, независимо от типа. Ограничение типа изменить нельзя.

text - хранит ссылку на отдельный кусок памяти, в которой располагается строка. Строка может быть неограничена. Встречается в других СУБД (MS SQL Server).

## Опции

NotNull (!= 0) - говорит об отсутствии значения.

Auto increment - автоматически увеличивает значение на 1.

Unique - строчка не должна повторяться.

Primary key - первичный ключ.

## Операции

__Соединение__ - создает новую таблицу из n+m столбцов. К каждой строке из первой таблицы припишем вторую.

__Объединение__ - приписываем к одной таблице вторую таблицу (как бы снизу), если у них одинаковые столбцы.

__Natural join__ - значения в столбцах с одними и теми же параметрами совпадает.

## Дамп и восстановление

### Dump

Дамп БД - позволяет переносить БД на другой ПК, создавая ее описание.

1. Выбрать БД.
2. Dump with pg_dump
3. Указать пути.
4. Statements=Insert with copy

### Восстановление

1. Создать новую БД.
2. Run SQL script.
3. Выбрать дамп.

## Заметки

1. Не забывать нажимать DB Submit после добавления записей (или других операций).

2. Delete rule=cascade - плохая практика в production.

3. Можно добавить столбец, показывающий, является ли запись "удаленной".

4. Вначале проходит выделение идентификатора, а только затем проверяются ограничения целостности.

5. Индексы ускоряют поиск записей.
