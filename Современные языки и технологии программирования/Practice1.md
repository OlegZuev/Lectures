# Практика 1

16.01.20

- [Практика 1](#Практика-1)
  - [Проверка числа на простоту](#Проверка-числа-на-простоту)
    - [Вариант 1](#Вариант-1)
    - [Вариант 2](#Вариант-2)
    - [Вариант 3](#Вариант-3)
    - [Вариант 4](#Вариант-4)
  - [Задание типа](#Задание-типа)
  - [Ввод-вывод](#Ввод-вывод)
    - [Вывод](#Вывод)
    - [Ввод](#Ввод)
    - [Ввод и вывод](#Ввод-и-вывод)
  - [Комментарии](#Комментарии)

## Проверка числа на простоту

### Вариант 1

```haskell
isPrime' n d =
    if d ^ 2 > n then True
    else if mod n d == 0 then False
    else isPrime' n (d + 1)

isPrime n = isPrime' n 2
```

Компиляция и запуск:

:load "filename.hs"

:reload

### Вариант 2

```haskell
isPrime n = isPrime' n 2 where
    isPrime' n d =
        if d ^ 2 > n then True
        else if mod n d == 0 then False
        else isPrime' n (d + 1)
```

### Вариант 3

```haskell
isPrime n =
    let isPrime' n d =
            if d ^ 2 > n then True
            else if mod n d == 0 then False
            else isPrime' n (d + 1)
    in isPrime' n 2
```

### Вариант 4

```haskell
isPrime 1 = False
isPrime n =
    let isPrime' n d =
            if d ^ 2 > n then True
            else if mod n d == 0 then False
            else isPrime' n (d + 1)
    in isPrime' n 2
```

Сопоставление производится по порядку.

## Задание типа

```haskell
isPrime :: Int -> Bool
```

## Ввод-вывод

### Вывод

```haskell
main putStrLn (show (isPrime 13))
```

```haskell
print $ (isPrime 13)
```

### Ввод

```haskell
main =
    do -- не соответствует ФП; инструкции выполнять по порядку, может нарушаться чистота функций
        n <- getLine
```

### Ввод и вывод

```haskell
main =
    do -- не соответствует ФП; инструкции выполнять по порядку, может нарушаться чистота функций
        n <- getLine
        print $ (isPrime (read n))
```

## Комментарии

```haskell
-- main putStrLn (show (isPrime 13))
```
