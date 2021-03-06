# Лекция 3

23.01.20

- [Лекция 3](#Лекция-3)
  - [Списки](#Списки)
    - [Способы задания списков](#Способы-задания-списков)
    - [Работа со списками](#Работа-со-списками)
    - [Функции](#Функции)
  - [Описание функции](#Описание-функции)
    - [Хвостовая рекурсия](#Хвостовая-рекурсия)
    - [Функции высших порядков](#Функции-высших-порядков)
    - [Встроенные функции для работы со списками](#Встроенные-функции-для-работы-со-списками)
  - [Кортежи](#Кортежи)
  - [Прямоугольные треугольники - задача](#Прямоугольные-треугольники---задача)

## Списки

Списки задаются в [].

- [1, 2, 3] - список их трех чисел
- [] - пустой список. Базовый тип не определен

: - отделение первого элемента списка (головы) от остальной части (хвоста). Это позволяет как добавить элемент, так и разделить список.

- 1 : [2, 3] - список [1, 2, 3]
- 1 : 2 : 3 : [] - список [1, 2, 3]. Операция выполняется справа налево. Справа обязательно должен быть список
- 'a' : [2, 3] - ошибка несоответствия типов
- ['a', 'b', 'c'] - строка "abc"

Операция "++" - склейка списков.

- [1, 2] ++ [3, 4] - список [1, 2, 3, 4]

### Способы задания списков

1. Перечисление элементов [1, 2, 3, 4]

2. Диапазон [1 .. 4]

    Задание арифметической прогрессии - [1, 3 .. 9] - список нечетных чисел [1, 3, 5, 7, 9]

3. Генераторы списков

    [выражение с параметром | параметр <- список значений, условие]

    Пример:

    ```haskell
    [x*x | x <- [1..10]] -- список квадратов чисел от 1 до 10
    ```

    Параметров может быть несколько:

    ```haskell
    [10*x + y | x <- [1..3], y <- [1..4]] -- список [11, 12, 13, 14, 21, 22, 23, 24, 31, 32, 33, 34]
    ```

    Функция, которая создает список всех делителей числа:

    ```haskell
    divisors n = [d | d <- [1..n], n `mod` d = 0]
    ```

Нет базового типа "строка". Любая строка - список символов.

### Работа со списками

!! - обращение к списку по номеру

```haskell
[1..10]!! 3 -- 4
```

< <= > >= = - сравнение происходит в лексикографическом порядке. Элементы списка должны быть одного типа и быть сравниваемыми.

### Функции

__head__ - первый элемент

__tail__ - все, кроме первого элемента

__init__ - все, кроме последнего элемента

__last__ - последний элемент

__length__ - длина списка

__reverse__ - разворачивает список

__take n lst__ - возвращает первые n элементов у списка

__max__ - максимальный элемент

__min__ - минимальный элемент

__sum__ - сумма элементов

__product__ - произведение элементов

__elem__ - проверяет наличие элемента

## Описание функции

```haskell
-- version 1
mySum [] = 0

-- сопоставление с шаблоном (pattern matching)
mySum (h : t) =
    h + mySum t
```

### Хвостовая рекурсия

__Хвостовая рекурсия__ - способ построения, при которой рекурсивный вызов является последней выполняемой операцией.

```haskell
-- version 2
mySum lst = mySum' lst 0 where
    mySum' [] acc = acc
    mySum' (h : t) acc = mySum' t (acc + h)
```

Можно упростить задачу, передавая функцию в качестве параметра.

### Функции высших порядков

__Функции высших порядков__ - функции, в которых хотя бы один из аргументов - другая функция.

Функция, позволяющая выполнять свертку списков:

```haskell
myFold f acc [] = acc

myFold f acc (h : t) =
    myFold f (f acc h) t
```

```haskell
-- version 3
mySum lst =
    myFold (+) 0 lst
```

### Встроенные функции для работы со списками

1. __foldl__ :: (a -> b -> a) -> a -> [b] -> a

    Аналог написанной нами функции myFold

    Тип аккумулятора и тип значения списка могут не совпадать!

    Идет по списку слева направо. foldl сохраняет порядок.

    __foldr__ - идет по списку справа налево.

2. __filter__ :: (a -> Bool) -> [a] -> [a]

3. __map__ :: (a -> b) -> [a] -> [b]

    Пример:

    ```haskell
    upperCase str =
        map toUpCase str where
            toUpCase ch =
                if ch == 'a' then 'A'
                else if ch == 'b' then 'B'
                -- ...
                else ch
    ```

## Кортежи

__Кортежи__ - наборы значений разных типов, но фиксированной длины.

(элемент1, элемент2, элементN).

Примеры:

```haskell
(23, "января")
```

Для кортежей можно использовать сопоставление с шаблоном.

```haskell
-- возвращает первый элемент
myFirst (a, b) = a
```

__fst__ - возвращает первый элемент кортежа из двух эдементов.

__snd__ - возвращает второй элемент кортежа из двух элементов.

## Прямоугольные треугольники - задача

Создать все прямоугольные треугольники с целочисленными длинами сторон, не превышающими 100.

```haskell
[(a, b, c) | c <- [1..100],
             b <- [1..c-1],
             a <- [1, b],
             a*a + b*b == c*c]
```
